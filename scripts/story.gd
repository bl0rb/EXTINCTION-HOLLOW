class_name Story
extends Node
## The meteor arc (GAME_SPEC §40-§47, §125-§126, §149.29): five world phases, each more dangerous than the last,
## told in short chapter texts and by a star that grows in the sky. When it strikes, only a strong enough cave saves the dino.

signal chapter_started(index: int)
signal impact_started
signal ended(survived: bool)

const PHASE_START := [0.0, 480.0, 1080.0, 1800.0, 2520.0] ## seconds of play when each phase begins
const IMPACT := 3000.0 ## the meteor strikes after 50 minutes
const WARNING := 180.0 ## the final warning: meteorites rain down, everything flees
const DISASTER_PACE := [2.0, 1.2, 0.8, 0.55, 0.35] ## multiplies the time between disasters
const SHELTER_NEEDED := 12 ## cave points (see Cave.shelter) to live through the impact
const CHAPTERS := [
	{"title": "I   THE HOLLOW", "text": "The hollow is quiet. The herds graze, the rivers run. Nothing here remembers the sky."},
	{"title": "II   UNREST", "text": "The ground trembles. Far beyond the steppe, the mountain is waking."},
	{"title": "III   FIRE", "text": "Ash falls like snow. The herds run east, then west, then nowhere."},
	{"title": "IV   OMENS", "text": "A new star burns in the sky. Every night it is brighter."},
	{"title": "V   THE LAST DAYS", "text": "The star has a tail now. Bring everything home. The hollow is all that is left."},
]
## Environmental storytelling: what the dino finds out in the world.
const LORE := {
	"bones": {"kind": 0, "text": "Bones older than the trees. They lie curled up, as if sleeping through something."},
	"claws": {"kind": 1, "text": "Claw marks on the rock, thousands of them. Someone counted the days here."},
	"giant": {"kind": 0, "text": "A giant, stripped bare by the wind. Its skull still stares at the sky."},
	"stones": {"kind": 2, "text": "Smooth stones laid in a ring. The river has not moved them in an age."},
	"tracks": {"kind": 1, "text": "Tracks sink into the mud and never come out again."},
	"glass": {"kind": 2, "text": "Black glass, still warm. The mountain has done this before."},
	"ice": {"kind": 0, "text": "Beasts frozen beneath the ice, their eyes still open. They were running."},
	"star": {"kind": 1, "text": "Scratched into the wall: a burning star. Below it, one small shape inside a hollow."},
}
const LORE_XP := 15
const METEOR_LIGHT := Color(0.62, 0.34, 0.24)

var time := 0.0 ## seconds of play in this age
var phase := 0
var found := {} ## lore id -> true
var state := &"running" ## running, impact, over
var survived := false
var _shower := 0.0
var _impact_time := 0.0
var _hum: AudioStreamPlayer ## the meteor fills the sky with a drone (T099)

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var disasters: Disasters = get_tree().get_first_node_in_group("disasters")
@onready var weather: Weather = get_tree().get_first_node_in_group("weather")


func _ready() -> void:
	time = SaveGame.read("story", "time", 0.0)
	found = SaveGame.read("story", "found", {})
	phase = phase_at(time)
	_pace_disasters()
	_hum = Sound.loop(self, "meteor")
	# the opening words of the age, once the HUD is listening
	(func() -> void: chapter_started.emit(phase)).call_deferred()


static func phase_at(seconds: float) -> int:
	var p := 0
	while p + 1 < PHASE_START.size() and seconds >= PHASE_START[p + 1]:
		p += 1
	return p


## 0 at the start of the age, 1 at the impact.
func progress() -> float:
	return clampf(time / IMPACT, 0.0, 1.0)


func time_left() -> float:
	return maxf(IMPACT - time, 0.0)


func warning() -> bool:
	return state == &"running" and time_left() <= WARNING


## A lore site was reached: tell its story once and reward the curiosity.
func discover(id: String) -> bool:
	if found.has(id):
		return false
	found[id] = true
	player.gain_xp(LORE_XP)
	player.carried_xp += LORE_XP
	return true


func _process(delta: float) -> void:
	# the hum swells as the meteor comes closer and falls silent with the impact
	var hum := clampf((progress() - 0.45) / 0.55, 0.0, 1.0) * (0.35 if Biomes.at(player.global_position) == Biomes.DUNGEON else 1.0)
	Sound.fade(_hum, hum if state == &"running" else 0.0, delta, 0.3 if state == &"running" else 2.0)
	if state == &"over":
		return
	if state == &"impact":
		_impact_time += delta
		if _impact_time >= 4.0:
			_finish()
		return
	time += delta
	var now := phase_at(time)
	if now != phase:
		phase = now
		_pace_disasters()
		chapter_started.emit(phase)
	# the meteor lights the world orange-red in the last phases
	weather.meteor_glow = clampf((progress() - 0.55) / 0.45, 0.0, 1.0) * 0.8
	if warning():
		_final_minutes(delta)
	if time >= IMPACT:
		_impact()


func _pace_disasters() -> void:
	disasters.min_interval = 150.0 * DISASTER_PACE[phase]
	disasters.max_interval = 300.0 * DISASTER_PACE[phase]
	disasters._timer = minf(disasters._timer, disasters.max_interval)


## The last minutes: meteorites crash down around the dino and every animal runs.
func _final_minutes(delta: float) -> void:
	_shower -= delta
	if _shower > 0.0:
		return
	_shower = randf_range(1.2, 2.6)
	if Biomes.at(player.global_position) == Biomes.DUNGEON:
		return # the rock above keeps the meteorites out
	var target := player.global_position + Vector2(randf_range(-260, 260), randf_range(-160, 160))
	if randf() < 0.25:
		target = player.global_position + Vector2(randf_range(-20, 20), randf_range(-14, 14))
	var rock: Node2D = Disasters.LAVA_BOMB.instantiate()
	rock.start = target + Vector2(90, -30)
	rock.start_height = 420.0
	rock.arc = 0.0
	rock.flight_time = 1.1
	rock.target = target
	rock.damage = 18.0
	player.get_parent().add_child(rock)
	for animal: Animal in get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator"):
		if animal.global_position.distance_to(target) < 200.0:
			animal.panic(target, 3.0)


## Light, then silence (GAME_SPEC §44, §126).
func _impact() -> void:
	state = &"impact"
	_impact_time = 0.0
	survived = cave.overlaps_body(player) and cave.shelter() >= SHELTER_NEEDED and not player.dead
	player.camera.shake(8.0, 3.0)
	Sound.play(player.get_parent(), "impact", player.global_position, 6.0, 1.0, 5000.0)
	impact_started.emit()


func _finish() -> void:
	state = &"over"
	if not survived:
		player.carried_xp = 0
	ended.emit(survived)


## A new age begins: the world starts over, the dino keeps what it has learned and found.
## Surviving keeps the cave; extinction costs it and everything that was banked.
func new_age() -> void:
	var file := ConfigFile.new()
	file.load(SaveGame.PATH)
	file.set_value("story", "time", 0.0)
	file.set_value("story", "found", {})
	file.set_value("map", "explored", PackedByteArray())
	file.set_value("world", "seed", randi_range(1, 999999)) # a new world for the new age
	if not survived:
		file.set_value("cave", "levels", {})
		file.set_value("player", "banked_xp", 0)
		file.set_value("player", "upgrades", {})
	file.save(SaveGame.PATH)
	get_tree().reload_current_scene()
