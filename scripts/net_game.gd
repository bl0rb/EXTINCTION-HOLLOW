class_name NetGame
extends Node
## A multiplayer round (GAME_SPEC §155): the land is emptied as in survival, the other players' dinos appear,
## our own dino's state streams to them, and the mode (versus or survival) takes over.

const SEND_RATE := 0.05 ## seconds between two state updates of our dino

var dinos := {} ## peer id -> RemoteDino
var _send := 0.0

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var weather: Weather = get_tree().get_first_node_in_group("weather")
@onready var actors: Node2D = get_node("../Actors")


func _ready() -> void:
	name = "NetGame"
	add_to_group("net_game")
	Net.hub().message.connect(_on_message)
	Survival.empty_land(get_parent())
	get_parent().get_node("Disasters").process_mode = Node.PROCESS_MODE_DISABLED # the same sky for everyone
	weather.set_weather(Weather.Kind.CLEAR, INF, true)
	player.respawns = false
	for id: int in Net.players:
		if id != Net.my_id():
			_add_dino(id)
	_place_player()
	get_parent().add_child(Survival.new() if Net.mode == "survival" else Versus.new())


func _physics_process(delta: float) -> void:
	_send -= delta
	if _send <= 0.0:
		_send = SEND_RATE
		Net.send("state", player.net_state(), 0, true)


func _add_dino(id: int) -> void:
	var dino := RemoteDino.create(id, Net.players[id])
	if Net.mode == "versus":
		dino.add_to_group("prey") # something to bite
	actors.add_child(dino)
	dinos[id] = dino


## Everyone starts around the middle of the land, each at their own place.
func _place_player() -> void:
	await Survival.map_ready(player)
	var ids: Array = Net.players.keys()
	ids.sort()
	var angle := TAU * ids.find(Net.my_id()) / maxf(ids.size(), 1.0)
	var reach := 200.0 if Net.mode == "versus" else 50.0
	player.global_position = Survival.open_ground(player, Vector2(1536, 768) + Vector2(cos(angle), sin(angle) * 0.6) * reach)
	player.camera.reset_smoothing()


func _on_message(sender: int, kind: String, args: Array) -> void:
	match kind:
		"state":
			if dinos.has(sender):
				dinos[sender].apply_state(args)
		"fx":
			if dinos.has(sender):
				dinos[sender].play_fx(args[0], args[1], args[2])
		"left":
			if dinos.has(sender):
				dinos[sender].queue_free()
				dinos.erase(sender)
