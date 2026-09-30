class_name Versus
extends Node
## Versus (GAME_SPEC §155): the dinos fight each other. Bites and skills hit the other dinos (their owners decide),
## a fallen dino comes back after a moment somewhere else, shielded for a while. First to ten kills wins,
## or whoever has the most kills after five minutes.

const KILLS_TO_WIN := 10
const MATCH_TIME := 300.0
const RESPAWN := 3.0
const GUARD := 2.5 ## seconds a dino that came back cannot be hurt

var scores := {} ## peer id -> kills
var time_left := MATCH_TIME
var over := false
var _respawn := 0.0
var _clock_send := 0.0

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var hud = get_tree().get_first_node_in_group("hud")


func _ready() -> void:
	name = "Versus"
	add_to_group("versus")
	Net.hub().message.connect(_on_message)
	player.died.connect(_on_died)
	player.hunger_rate = 0.0 # nothing to eat here
	for id: int in Net.players:
		scores[id] = 0
	hud.narrate("VERSUS", "First to %d kills wins." % KILLS_TO_WIN)


func _process(delta: float) -> void:
	if over:
		return
	if Net.is_host():
		time_left -= delta
		_clock_send -= delta
		if _clock_send <= 0.0:
			_clock_send = 0.5
			Net.send("clock", [time_left], 0, true)
		if time_left <= 0.0:
			_finish()
	if player.dead:
		_respawn -= delta
		if _respawn <= 0.0:
			player.revive(_spawn_point(), GUARD)


## The name of a player, for the kill feed and the end screen.
func name_of(id: int) -> String:
	return str(Net.players.get(id, {}).get("name", "?"))


func _on_died() -> void:
	_respawn = RESPAWN
	var killer := player.last_attacker
	Net.send("frag", [killer, Net.my_id()])
	_frag(killer, Net.my_id())


func _frag(killer: int, victim: int) -> void:
	if killer != 0 and killer != victim:
		scores[killer] = scores.get(killer, 0) + 1
		hud.show_warning("%s bit %s" % [name_of(killer).to_upper(), name_of(victim).to_upper()])
		if killer == Net.my_id():
			player.gain_xp(15 + 5 * int(Net.players.get(victim, {}).get("level", 1)))
			Fx.text(player, player.global_position + Vector2(0, -34), "KILL", Fx.GOLD, 16)
		if Net.is_host() and scores[killer] >= KILLS_TO_WIN:
			_finish()


func _finish() -> void:
	var winner := 0
	for id: int in scores:
		if winner == 0 or scores[id] > scores[winner]:
			winner = id
	Net.send("over", [winner])
	_over(winner)


func _over(winner: int) -> void:
	over = true
	SaveGame.store(player, cave, true)
	var won := winner == Net.my_id()
	hud.show_end("VICTORY" if won else "DEFEAT", Fx.GOLD if won else Fx.HURT,
		"%s wins with %d kills" % [name_of(winner), scores.get(winner, 0)],
		"click to go back to the lobby" if Net.is_host() else "the host starts the next round", func() -> void: Net.back_to_lobby())


## Somewhere open, away from the other dinos.
func _spawn_point() -> Vector2:
	var best := player.global_position
	var best_gap := -1.0
	for i in 8:
		var candidate := Survival.open_ground(player, Vector2(randf_range(400, 2600), randf_range(300, 1200)))
		var gap := INF
		for dino in get_tree().get_nodes_in_group("remote_dinos"):
			gap = minf(gap, candidate.distance_to(dino.global_position))
		if gap > best_gap:
			best = candidate
			best_gap = gap
	return best


func _on_message(sender: int, kind: String, args: Array) -> void:
	match kind:
		"pvp":
			if not over:
				player.last_attacker = sender
				player.take_damage(args[0], get_tree().get_first_node_in_group("net_game").dinos.get(sender))
		"frag":
			_frag(args[0], args[1])
		"clock":
			time_left = args[0]
		"over":
			_over(args[0])
		"left":
			scores.erase(sender)
