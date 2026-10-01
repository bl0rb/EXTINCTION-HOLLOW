class_name Survival
extends Node
## Survival mode (GAME_SPEC §154, §155): no cave, no age and no meteor. Monsters stream at the dinos in ever larger waves,
## with elites and an ULTRABOSS every fifth wave that stomps the ground and calls for help. Level, skills and items are the
## same as in the standard game and are kept; the game is saved after every wave and when the run ends.
## In a multiplayer game the host runs the waves and sends them to the others, whose bites go back to the host.

signal wave_started(number: int)

const BREAK := 8.0 ## seconds between two waves
const FIRST_BREAK := 4.0
const TRICKLE := 0.35 ## seconds between monsters streaming in
const SEND_RATE := 0.066 ## seconds between two monster updates to the others
const STOMP_EVERY := 6.0 ## the ultraboss stomps ...
const STOMP_WARN := 0.8 ## ... after a warning ring ...
const STOMP_REACH := 90.0 ## ... and hurts every dino this close
const SUMMON_EVERY := 15.0 ## and calls three raptors
const SCENES := {
	"compy": "res://scenes/compy.tscn", "lizard": "res://scenes/lizard.tscn", "raptor": "res://scenes/raptor.tscn",
	"proto": "res://scenes/proto.tscn", "ankylo": "res://scenes/ankylo.tscn", "snowrunner": "res://scenes/snowrunner.tscn",
	"allosaurus": "res://scenes/predator.tscn",
}
const TITLES := ["", "ELITE", "ALPHA", "ULTRABOSS"]

var wave := 0
var best := 0 ## the best wave of this dino so far
var kills := 0
var over := false
var alive: Array = [] ## host: the monsters of this wave (untyped: they may have been freed)
var break_left := FIRST_BREAK
var boss: Animal ## the ultraboss while it lives
var host := true ## runs the waves (single player or the host of a multiplayer game)
var _queue: Array = [] ## [kind, rank] still to stream in
var _trickle := 0.0
var _clock := 0.0
var _send := 0.0
var _next_id := 1
var _left := 0 ## client: monsters left, as the host says
var _puppets := {} ## client: net id -> copy of a monster
var _goals := {} ## client: net id -> where its copy is heading
var _down := {} ## host: peer ids of fallen dinos

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var weather: Weather = get_tree().get_first_node_in_group("weather")
@onready var hud = get_tree().get_first_node_in_group("hud")
@onready var actors: Node2D = get_node("../Actors")


func _ready() -> void:
	name = "Survival"
	add_to_group("survival")
	host = not Net.active or Net.is_host()
	player.respawns = false
	best = SaveGame.read("survival", "best", 0)
	player.died.connect(_on_died)
	Net.hub().message.connect(_on_message)
	empty_land(get_parent())
	hud.narrate("SURVIVAL", "No cave, no mercy. Hold out as long as you can." if not Net.active else "Together against the waves.")
	if not Net.active:
		_place_player()


## No cave to hide in, no dungeons to wander off into, no animals: only what the mode brings.
static func empty_land(main: Node) -> void:
	var tree := main.get_tree()
	var home := tree.get_first_node_in_group("cave") as Cave
	home.monitoring = false
	home.monitorable = false
	for door in tree.get_nodes_in_group("dungeon_entrance"):
		door.monitoring = false
		door.hide()
	for node in main.get_children():
		if node.get_script() and node.get_script().resource_path.ends_with("spawner.gd"):
			node.process_mode = Node.PROCESS_MODE_DISABLED
	for animal in tree.get_nodes_in_group("prey") + tree.get_nodes_in_group("predator"):
		if not animal is RemoteDino:
			animal.queue_free()


## Waits until the navigation map of the land is ready to be asked.
static func map_ready(node: Node2D) -> void:
	for i in 60:
		await node.get_tree().physics_frame
		if NavigationServer2D.map_get_iteration_id(node.get_world_2d().navigation_map) > 0:
			return


## The nearest point the animals can walk to.
static func open_ground(node: Node2D, near: Vector2) -> Vector2:
	var point := NavigationServer2D.map_get_closest_point(node.get_world_2d().navigation_map, near)
	return point if point != Vector2.ZERO else near


## The run starts in the middle of the land, once the navigation map is ready.
func _place_player() -> void:
	await map_ready(player)
	player.global_position = open_ground(player, Vector2(1536, 768))
	player.camera.reset_smoothing()


func _process(delta: float) -> void:
	if over:
		return
	if not host:
		_follow_puppets(delta)
		return
	_clock += delta
	weather.time_of_day = fmod(_clock / Weather.DAY_LENGTH + 0.3, 1.0)
	alive = alive.filter(func(beast) -> bool: return is_instance_valid(beast) and not beast.is_queued_for_deletion())
	if Net.active:
		_send -= delta
		if _send <= 0.0:
			_send = SEND_RATE
			_broadcast()
	if is_instance_valid(boss):
		_ultraboss(delta)
	if break_left > 0.0:
		break_left -= delta
		if break_left <= 0.0:
			_start_wave()
		return
	_trickle -= delta
	if not _queue.is_empty() and _trickle <= 0.0:
		_trickle = TRICKLE
		var next: Array = _queue.pop_front()
		_spawn(next[0], next[1], _spawn_point())
	if _queue.is_empty() and alive.is_empty():
		_clear_wave()


## Monsters still to beat in this wave.
func left() -> int:
	return alive.size() + _queue.size() if host else _left


## What a wave brings: more monsters every time, bigger ones later, elites from wave 3 and an ultraboss every fifth wave.
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
		list.append(["allosaurus", 3])
	return list


func _start_wave() -> void:
	wave += 1
	_queue = compose(wave)
	_trickle = 0.0
	_announce_wave(wave)
	Net.send("wave", [wave])
	wave_started.emit(wave)


func _announce_wave(number: int) -> void:
	hud.narrate(tr("WAVE %d") % number, "The ULTRABOSS is coming." if number % 5 == 0 else "They are coming.")


func _clear_wave() -> void:
	break_left = BREAK
	Net.send("cleared", [wave])
	_breather(wave)
	# the fallen get up again next to someone still standing
	var standing: Array = get_tree().get_nodes_in_group("dinos").filter(func(dino) -> bool: return not dino.dead)
	var spot: Vector2 = standing[0].global_position if not standing.is_empty() else player.global_position
	for id: int in _down:
		Net.send("revive", [spot + Vector2(randf_range(-20, 20), randf_range(-12, 12))], id)
	_down.clear()
	if player.dead:
		player.revive(spot)


## Between waves: some health, all stamina, a bite to eat, and the game is saved.
func _breather(number: int) -> void:
	player.health = minf(player.health + 0.3 * player.max_health(), player.max_health())
	player.stamina = player.max_stamina
	player.hunger = minf(player.hunger + 30.0, player.max_hunger)
	player.carried_xp = 0 # there is no cave to bring it to; the XP already counts for the level
	_save()
	hud.narrate(tr("WAVE %d CLEARED") % number, "Catch your breath.")


func _spawn(kind: String, rank: int, at: Vector2) -> Animal:
	var beast: Animal = load(SCENES[kind]).instantiate()
	beast.position = at
	actors.add_child(beast)
	beast.hostile = true
	beast.relentless = true
	beast.rank = rank
	beast.net_id = _next_id
	beast.set_meta("kind", kind)
	_next_id += 1
	var toughness := 1.0 + 0.2 * (wave - 1)
	beast.power = 1.0 + 0.1 * (wave - 1)
	var dinos := get_tree().get_nodes_in_group("dinos").size()
	toughness *= [1.0, 3.0, 5.0, 6.0 + 3.0 * dinos][rank]
	beast.power *= [1.0, 1.5, 1.4, 1.8][rank]
	_dress(beast, rank)
	beast.max_health *= toughness
	beast.health = beast.max_health
	beast.tree_exiting.connect(_on_beast_gone.bind(beast))
	alive.append(beast)
	if rank == 3:
		boss = beast
		beast.set_meta("stomp", STOMP_EVERY)
		beast.set_meta("summon", SUMMON_EVERY)
		beast.add_to_group("boss")
	return beast


## Elites, alphas and the ultraboss are bigger and tinted, with their title above them.
static func _dress(beast: Animal, rank: int) -> void:
	beast.title = TITLES[rank]
	beast.rank = rank
	if rank > 0:
		beast.sprite.scale *= [1.0, 1.25, 1.5, 2.2][rank]
		beast.sprite.self_modulate = [Color.WHITE, Color(1.35, 1.1, 0.6), Color(1.4, 0.75, 0.65), Color(0.9, 0.45, 0.5)][rank]


## The ultraboss stomps (a red warning ring, then a shockwave that hurts every dino close by) and calls raptors.
func _ultraboss(delta: float) -> void:
	var stomp: float = boss.get_meta("stomp") - delta
	if stomp <= STOMP_WARN and boss.get_meta("stomp") > STOMP_WARN:
		_stomp_fx(boss.global_position, true)
		Net.send("stomp", [boss.global_position, true])
	if stomp <= 0.0:
		stomp = STOMP_EVERY
		_stomp_fx(boss.global_position, false)
		Net.send("stomp", [boss.global_position, false])
		for dino in get_tree().get_nodes_in_group("dinos"):
			if not dino.dead and dino.global_position.distance_to(boss.global_position) < STOMP_REACH:
				boss._bite_dino(dino, 22.0 * boss.power)
	boss.set_meta("stomp", stomp)
	var summon: float = boss.get_meta("summon") - delta
	if summon <= 0.0:
		summon = SUMMON_EVERY
		for i in 3:
			_spawn("raptor", 0, open_ground(boss, boss.global_position + Vector2.from_angle(TAU * i / 3.0) * 40.0))
	boss.set_meta("summon", summon)


func _stomp_fx(at: Vector2, warning: bool) -> void:
	if warning:
		SkillFx.ring(actors, at, STOMP_REACH, Fx.HURT, STOMP_WARN)
	else:
		SkillFx.ring(actors, at, STOMP_REACH * 1.3, Color(1.0, 0.5, 0.3), 0.5)
		SkillFx.dust_ring(actors, at, 30.0, 10)
		player.camera.shake(4.0, 0.3)


## Just outside the view of a dino still standing, on ground the monsters can walk on.
func _spawn_point() -> Vector2:
	var standing: Array = get_tree().get_nodes_in_group("dinos").filter(func(dino) -> bool: return not dino.dead)
	var around: Vector2 = standing.pick_random().global_position if not standing.is_empty() else player.global_position
	var angle := randf() * TAU
	return open_ground(player, around + Vector2(cos(angle) * randf_range(340, 400), sin(angle) * randf_range(200, 240)))


## Host: a monster is gone; if it was killed, the killer gets the kill and the others a share of the XP.
func _on_beast_gone(beast: Animal) -> void:
	if over or beast.health > 0.0:
		return
	kills += 1
	var hitter: int = beast.get_meta("hitter", Net.my_id())
	var kind_id: int = SCENES.keys().find(beast.get_meta("kind"))
	Net.send("kill", [hitter, kind_id, beast.rank, beast.global_position, beast.net_id])
	if hitter != Net.my_id():
		player.reward_kill(beast.species, beast.global_position, beast.get_size(), beast.rank, 0.5)


## Host: where every monster is, and how the wave stands, for the others.
func _broadcast() -> void:
	var list := []
	for beast in alive:
		list.append_array([beast.net_id, SCENES.keys().find(beast.get_meta("kind")), beast.rank, beast.global_position,
			beast.sprite.frame, beast.sprite.scale.x / absf(beast.sprite.scale.y), beast.health, beast.max_health])
	Net.send("monsters", [wave, left(), break_left, kills, weather.time_of_day, list], 0, true)


## Client: copies of the host's monsters follow what the host sends.
func _update_puppets(args: Array) -> void:
	wave = args[0]
	_left = args[1]
	break_left = args[2]
	kills = args[3]
	weather.time_of_day = args[4]
	var list: Array = args[5]
	var seen := {}
	for i in range(0, list.size(), 8):
		var id: int = list[i]
		seen[id] = true
		var copy: Animal = _puppets.get(id)
		if copy == null or not is_instance_valid(copy):
			copy = load(SCENES.values()[list[i + 1]]).instantiate()
			copy.puppet = true
			copy.net_id = id
			copy.process_mode = Node.PROCESS_MODE_DISABLED
			copy.position = list[i + 3]
			actors.add_child(copy)
			_dress(copy, list[i + 2])
			if list[i + 2] == 3:
				boss = copy
			_puppets[id] = copy
		_goals[id] = list[i + 3]
		copy.sprite.frame = list[i + 4]
		copy.sprite.scale.x = absf(copy.sprite.scale.y) * list[i + 5]
		if copy.has_node("Sprite2D/Eyes"):
			copy.get_node("Sprite2D/Eyes").frame = copy.sprite.frame
		copy.health = list[i + 6]
		copy.max_health = list[i + 7]
	for id: int in _puppets.keys():
		if not seen.has(id):
			_drop_puppet(id)


func _follow_puppets(delta: float) -> void:
	for id: int in _puppets:
		var copy = _puppets[id]
		if is_instance_valid(copy):
			copy.global_position = copy.global_position.lerp(_goals.get(id, copy.global_position), minf(1.0, delta * 15.0))


func _drop_puppet(id: int) -> void:
	var copy = _puppets.get(id)
	if is_instance_valid(copy):
		copy.queue_free()
	_puppets.erase(id)
	_goals.erase(id)


func _save() -> void:
	SaveGame.store(player, cave, true)
	best = maxi(best, wave)
	SaveGame.write("survival", "best", best)


func _on_died() -> void:
	if Net.active:
		hud.narrate("YOU ARE DOWN", "Hold on - you get up when the wave is beaten.")
		if host:
			_check_all_down()
		else:
			Net.send("down", [], 1)
		return
	_end_run()


## Host: when every dino is down, the run is over for everyone.
func _check_all_down() -> void:
	for dino in get_tree().get_nodes_in_group("dinos"):
		if not dino.dead and not (dino is RemoteDino and _down.has(dino.peer_id)):
			return
	Net.send("over", [wave, kills])
	_end_run()


func _end_run() -> void:
	over = true
	player.carried_xp = 0
	_save()
	var text := tr("Wave %d  -  %d monsters beaten") % [wave, kills] + "\n" + tr("Best wave: %d") % best
	if Net.active:
		hud.show_end("FALLEN", Fx.HURT, text, "click to go back to the lobby" if Net.is_host() else "the host starts the next round",
			func() -> void: Net.back_to_lobby())
	else:
		hud.show_end("FALLEN", Fx.HURT, text, "click to try again", func() -> void: get_tree().reload_current_scene())


func _on_message(sender: int, kind: String, args: Array) -> void:
	match kind:
		"monsters":
			_update_puppets(args)
		"wave":
			_announce_wave(args[0])
		"cleared":
			_breather(args[0])
		"revive":
			player.revive(args[0])
		"kill":
			Fx.burst(Fx.BLOOD, actors, args[3] + Vector2(0, -4))
			_drop_puppet(args[4])
			var species := _species_of(args[1])
			player.reward_kill(species, args[3], species.size, args[2], 1.0 if args[0] == Net.my_id() else 0.5)
		"hurt":
			player.take_damage(args[0], _puppets.get(args[1]))
		"stomp":
			_stomp_fx(args[0], args[1])
		"down":
			if host:
				_down[sender] = true
				_check_all_down()
		"hit":
			if host:
				for beast in alive:
					if beast.net_id == args[0]:
						beast.set_meta("hitter", sender)
						var from: Node2D = get_tree().get_first_node_in_group("net_game").dinos.get(sender, player)
						beast.hit(args[1], from, args[2])
						break
		"over":
			_end_run()
		"left":
			_down.erase(sender)
			if host and not over:
				_check_all_down.call_deferred()


## The species of a monster kind, for rewards on a client.
static func _species_of(kind_id: int) -> Species:
	var path: String = SCENES.values()[kind_id]
	var state := (load(path) as PackedScene).get_state()
	for i in state.get_node_property_count(0):
		if state.get_node_property_name(0, i) == "species":
			return state.get_node_property_value(0, i)
	return Species.new()
