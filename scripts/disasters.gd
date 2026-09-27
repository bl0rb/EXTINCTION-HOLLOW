class_name Disasters
extends Node
## Disaster system (GAME_SPEC §35-§39): a warning first, then an earthquake or a volcanic eruption.
## Animals sense it coming and panic; the cave keeps the player safe.

signal warning(text: String)

const EARTHQUAKE := preload("res://data/earthquake.tres")
const ERUPTION := preload("res://data/eruption.tres")
const FALLING_ROCK := preload("res://scenes/falling_rock.tscn")
const LAVA_BOMB := preload("res://scenes/lava_bomb.tscn")
const ASH_TIME := 90.0 ## seconds of ash rain after an eruption

@export var min_interval := 150.0
@export var max_interval := 300.0

var active: Disaster ## the running disaster, null while calm or warning
var pending: Disaster ## the disaster that has been announced
var _timer := 0.0
var _spawn := 0.0

@onready var _player: Player = get_tree().get_first_node_in_group("player")
@onready var _weather: Weather = get_tree().get_first_node_in_group("weather")
@onready var _volcano: Volcano = get_tree().get_first_node_in_group("volcano")
@onready var _actors: Node2D = get_node("../Actors")


func _ready() -> void:
	_timer = randf_range(min_interval, max_interval)


func trigger(disaster: Disaster) -> void:
	pending = disaster
	active = null
	_timer = disaster.warning_time
	warning.emit(disaster.warning_text)
	if disaster.type == &"eruption":
		_volcano.set_activity(Volcano.WARNING)
	# animals sense it before it starts
	var source := _source(disaster)
	for animal: Animal in get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator"):
		if animal.global_position.distance_to(source) < disaster.radius:
			animal.panic(source, disaster.warning_time + disaster.duration)


func _process(delta: float) -> void:
	_timer -= delta
	if pending == null:
		if _timer <= 0.0:
			trigger(EARTHQUAKE if randf() * (EARTHQUAKE.weight + ERUPTION.weight) < EARTHQUAKE.weight else ERUPTION)
	elif active == null:
		_shake(0.8 * pending.intensity) # small tremors
		if _timer <= 0.0:
			active = pending
			_timer = active.duration
			if active.type == &"eruption":
				_volcano.set_activity(Volcano.ERUPTING)
	else:
		_spawn -= delta
		if active.type == &"earthquake":
			_shake(3.0 * active.intensity)
			_weather.quake = 5.0
			if _spawn <= 0.0:
				_spawn = randf_range(0.25, 0.6)
				_drop_rock()
		else:
			_shake(2.0 * active.intensity)
			if _spawn <= 0.0:
				_spawn = randf_range(0.3, 0.7)
				_throw_bomb()
		if _timer <= 0.0:
			_end()


func _end() -> void:
	if active.type == &"eruption":
		_volcano.set_activity(Volcano.CALM)
		_weather.set_weather(Weather.Kind.ASH, ASH_TIME)
	_weather.quake = 0.0
	if active.type == &"earthquake":
		get_tree().call_group("navigation", "rebake") # fallen rocks block the way now
	active = null
	pending = null
	_timer = randf_range(min_interval, max_interval)


func _source(disaster: Disaster) -> Vector2:
	return _volcano.global_position if disaster.type == &"eruption" else _player.global_position


func _shake(strength: float) -> void:
	# eruptions are felt less far away from the volcano
	var falloff := 1.0
	if pending.type == &"eruption":
		falloff = clampf(1.2 - _player.global_position.distance_to(_volcano.global_position) / 1400.0, 0.25, 1.0)
	_player.camera.shake(strength * falloff, 0.1)


func _drop_rock() -> void:
	var rock: Node2D = FALLING_ROCK.instantiate()
	var near := randf() < 0.25 # some rocks come down right where the player stands
	rock.position = _player.global_position + (Vector2(randf_range(-12, 12), randf_range(-8, 8)) if near else Vector2(randf_range(-280, 280), randf_range(-170, 170)))
	rock.damage = active.damage
	_actors.add_child(rock)


func _throw_bomb() -> void:
	var target := _volcano.global_position + Vector2.from_angle(randf_range(0.2, PI - 0.2)) * randf_range(60, 520)
	if _player.global_position.distance_to(_volcano.global_position) < 560.0 and randf() < 0.3:
		target = _player.global_position + Vector2(randf_range(-30, 30), randf_range(-20, 20))
	var bomb: Node2D = LAVA_BOMB.instantiate()
	bomb.start = _volcano.global_position
	bomb.start_height = Volcano.CRATER_HEIGHT
	bomb.target = target
	bomb.damage = active.damage
	_actors.add_child(bomb)
