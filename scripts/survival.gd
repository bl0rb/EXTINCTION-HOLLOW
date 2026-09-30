class_name Survival
extends Node
## Survival mode (GAME_SPEC §154): no cave, no age and no meteor. Monsters stream at the dino in ever larger waves,
## with elites and an alpha every fifth wave. Level, skills and items are the same as in the standard game and are kept;
## the game is saved after every wave and when the dino falls, together with the best wave.

signal wave_started(number: int)

const BREAK := 8.0 ## seconds between two waves
const FIRST_BREAK := 4.0
const TRICKLE := 0.35 ## seconds between monsters streaming in
const SCENES := {
	"compy": "res://scenes/compy.tscn", "lizard": "res://scenes/lizard.tscn", "raptor": "res://scenes/raptor.tscn",
	"proto": "res://scenes/proto.tscn", "ankylo": "res://scenes/ankylo.tscn", "snowrunner": "res://scenes/snowrunner.tscn",
	"allosaurus": "res://scenes/predator.tscn",
}

var wave := 0
var best := 0 ## the best wave of this dino so far
var kills := 0
var over := false
var alive: Array = [] ## the monsters of this wave (untyped: they may have been freed)
var break_left := FIRST_BREAK
var _queue: Array = [] ## [kind, rank] still to stream in
var _trickle := 0.0
var _clock := 0.0

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var weather: Weather = get_tree().get_first_node_in_group("weather")
@onready var hud = get_tree().get_first_node_in_group("hud")
@onready var actors: Node2D = get_node("../Actors")


func _ready() -> void:
	name = "Survival"
	add_to_group("survival")
	player.respawns = false
	best = SaveGame.read("survival", "best", 0)
	player.died.connect(_on_died)
	# no cave to hide in, no dungeons to wander off into
	cave.monitoring = false
	cave.monitorable = false
	for door in get_tree().get_nodes_in_group("dungeon_entrance"):
		door.monitoring = false
		door.hide()
	# the land is empty; only the waves come
	for node in get_parent().get_children():
		if node.get_script() and node.get_script().resource_path.ends_with("spawner.gd"):
			node.process_mode = Node.PROCESS_MODE_DISABLED
	for animal in get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator"):
		animal.queue_free()
	hud.narrate("SURVIVAL", "No cave, no mercy. Hold out as long as you can.")
	_place_player()


## The run starts in the middle of the land, once the navigation map is ready.
func _place_player() -> void:
	for i in 2:
		await get_tree().physics_frame
	player.global_position = _open_ground(Vector2(1536, 768))
	player.camera.reset_smoothing()


func _process(delta: float) -> void:
	if over:
		return
	_clock += delta
	weather.time_of_day = fmod(_clock / Weather.DAY_LENGTH + 0.3, 1.0)
	alive = alive.filter(func(beast) -> bool: return is_instance_valid(beast) and not beast.is_queued_for_deletion())
	if break_left > 0.0:
		break_left -= delta
		if break_left <= 0.0:
			_start_wave()
		return
	_trickle -= delta
	if not _queue.is_empty() and _trickle <= 0.0:
		_trickle = TRICKLE
		var next: Array = _queue.pop_front()
		_spawn(next[0], next[1])
	if _queue.is_empty() and alive.is_empty():
		_clear_wave()


## Monsters still to beat in this wave.
func left() -> int:
	return alive.size() + _queue.size()


## What a wave brings: more monsters every time, bigger ones later, elites from wave 3 and an alpha every fifth wave.
static func compose(number: int) -> Array:
	var kinds := ["compy", "compy", "lizard"]
	if number >= 2:
		kinds += ["raptor", "snowrunner"]
	if number >= 3:
		kinds += ["proto", "raptor"]
	if number >= 5:
		kinds += ["ankylo", "raptor"]
	if number >= 7:
		kinds += ["allosaurus"]
	var list := []
	for i in mini(5 + 2 * number, 40):
		list.append([kinds.pick_random(), 0])
	for i in mini(number / 3, list.size()):
		list[i][1] = 1
	list.shuffle()
	if number % 5 == 0:
		list.append(["allosaurus", 2])
	return list


func _start_wave() -> void:
	wave += 1
	_queue = compose(wave)
	_trickle = 0.0
	hud.narrate("WAVE %d" % wave, "An alpha leads them." if wave % 5 == 0 else "They are coming.")
	wave_started.emit(wave)


func _clear_wave() -> void:
	break_left = BREAK
	# a breather: some health, all stamina and a bite to eat
	player.health = minf(player.health + 0.3 * player.max_health(), player.max_health())
	player.stamina = player.max_stamina
	player.hunger = minf(player.hunger + 30.0, player.max_hunger)
	player.carried_xp = 0 # there is no cave to bring it to; the XP already counts for the level
	_save()
	hud.narrate("WAVE %d CLEARED" % wave, "Catch your breath.")


func _spawn(kind: String, rank: int) -> void:
	var beast: Animal = load(SCENES[kind]).instantiate()
	beast.position = _spawn_point()
	actors.add_child(beast)
	beast.hostile = true
	beast.relentless = true
	beast.rank = rank
	var toughness := 1.0 + 0.2 * (wave - 1)
	beast.power = 1.0 + 0.1 * (wave - 1)
	if rank == 1:
		toughness *= 3.0
		beast.power *= 1.5
		beast.title = "ELITE"
		beast.sprite.scale *= 1.25
		beast.sprite.self_modulate = Color(1.35, 1.1, 0.6)
	elif rank == 2:
		toughness *= 5.0
		beast.power *= 1.4
		beast.title = "ALPHA"
		beast.sprite.scale *= 1.5
		beast.sprite.self_modulate = Color(1.4, 0.75, 0.65)
	beast.max_health *= toughness
	beast.health = beast.max_health
	beast.tree_exiting.connect(func() -> void: kills += 1 if not over else 0)
	alive.append(beast)


## Just outside the view, on ground the monsters can walk on.
func _spawn_point() -> Vector2:
	var angle := randf() * TAU
	return _open_ground(player.global_position + Vector2(cos(angle) * randf_range(340, 400), sin(angle) * randf_range(200, 240)))


func _open_ground(near: Vector2) -> Vector2:
	var map := player.get_world_2d().navigation_map
	var point := NavigationServer2D.map_get_closest_point(map, near)
	return point if point != Vector2.ZERO else near


func _save() -> void:
	SaveGame.store(player, cave)
	SaveGame.write("survival", "best", maxi(SaveGame.read("survival", "best", 0), wave))


func _on_died() -> void:
	over = true
	var best := maxi(SaveGame.read("survival", "best", 0), wave)
	player.carried_xp = 0
	_save()
	hud.show_end("FALLEN", Fx.HURT, "Wave %d  -  %d monsters beaten\nBest wave: %d" % [wave, kills, best], "click to try again",
		func() -> void: get_tree().reload_current_scene())
