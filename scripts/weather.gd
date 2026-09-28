class_name Weather
extends Node
## Weather (GAME_SPEC §30-§34, §149.15-16): long stable phases that blend into each other.
## Rain darkens the night and thickens the fog, heavy rain slows the dino, snow settles on the ground, ash follows eruptions.

enum Kind { CLEAR, RAIN, HEAVY_RAIN, SNOW, ASH }

const LOOKS := {
	Kind.CLEAR: {"name": "CLEAR", "light": Color(0.33, 0.38, 0.52), "fog": 1.0, "fog_color": Color(0.6, 0.7, 0.85), "wind": 1.0, "temp": 0.0, "speed": 1.0},
	Kind.RAIN: {"name": "RAIN", "light": Color(0.27, 0.31, 0.43), "fog": 1.5, "fog_color": Color(0.55, 0.64, 0.78), "wind": 1.8, "temp": -4.0, "speed": 1.0},
	Kind.HEAVY_RAIN: {"name": "HEAVY RAIN", "light": Color(0.21, 0.25, 0.36), "fog": 2.2, "fog_color": Color(0.5, 0.58, 0.72), "wind": 3.0, "temp": -7.0, "speed": 0.85},
	Kind.SNOW: {"name": "SNOW", "light": Color(0.42, 0.46, 0.6), "fog": 1.4, "fog_color": Color(0.8, 0.85, 0.95), "wind": 1.3, "temp": -30.0, "speed": 0.85},
	Kind.ASH: {"name": "ASH", "light": Color(0.36, 0.27, 0.24), "fog": 2.0, "fog_color": Color(0.5, 0.42, 0.38), "wind": 1.2, "temp": 3.0, "speed": 1.0},
}
## Random weather; snow and ash come from events and the world phases.
const CHANCES := {Kind.CLEAR: 5.0, Kind.RAIN: 3.0, Kind.HEAVY_RAIN: 1.0}
const TRANSITION := 6.0 ## seconds to blend into new weather
const BASE_TEMPERATURE := 24.0
const VOLCANO := Vector2(2690, 250) ## warms its surroundings
const DUNGEON_TEMPERATURE := 14.0
const DUNGEON_LIGHT := Color(0.13, 0.12, 0.16) ## underground only what glows can be seen

@export var min_duration := 70.0
@export var max_duration := 160.0

var kind := Kind.CLEAR
var snow_cover := 0.0 ## 0..1, grows while it snows and melts afterwards
var quake := 0.0 ## extra wind while the ground shakes
var look := {} ## current blend of the weather looks
var meteor_glow := 0.0 ## 0..1, the meteor tints the night orange-red (GAME_SPEC §149.30)
var _time_left := 0.0
var _blend := 1.0
var _from := {}
var _emitters := {} ## Kind -> particle emitters

@onready var _night: CanvasModulate = get_node("../Night")
@onready var _fog: ShaderMaterial = get_node("../Fog").material
@onready var _cover: ShaderMaterial = get_node("../SnowCover").material
@onready var _player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	_build_emitters()
	look = LOOKS[Kind.CLEAR].duplicate()
	set_weather(Kind.CLEAR, randf_range(min_duration, max_duration), true)


func set_weather(new_kind: Kind, duration: float, instant := false) -> void:
	kind = new_kind
	_time_left = duration
	_from = look.duplicate()
	_blend = 1.0 if instant else 0.0
	for k: Kind in _emitters:
		for emitter: CPUParticles2D in _emitters[k]:
			emitter.emitting = k == kind


func speed_factor() -> float:
	return look.speed


func temperature_at(pos: Vector2) -> float:
	if Biomes.at(pos) == Biomes.DUNGEON:
		return DUNGEON_TEMPERATURE # deep underground the weather does not reach
	# every region has its own climate: the open steppe is cold at night, the snowfields freeze
	var t: float = BASE_TEMPERATURE + look.temp + Biomes.TEMPERATURE[Biomes.at(pos)]
	return t + 14.0 * clampf(1.0 - pos.distance_to(VOLCANO) / 420.0, 0.0, 1.0)


func _process(delta: float) -> void:
	_time_left -= delta
	if _time_left <= 0.0:
		set_weather(_pick(), randf_range(min_duration, max_duration))
	_blend = minf(_blend + delta / TRANSITION, 1.0)
	var to: Dictionary = LOOKS[kind]
	look.name = to.name
	for key in ["fog", "wind", "temp", "speed"]:
		look[key] = lerpf(_from[key], to[key], _blend)
	for key in ["light", "fog_color"]:
		look[key] = (_from[key] as Color).lerp(to[key], _blend)
	var underground := Biomes.at(_player.global_position) == Biomes.DUNGEON
	_night.color = DUNGEON_LIGHT if underground else (look.light as Color).lerp(Story.METEOR_LIGHT, meteor_glow)
	_fog.set_shader_parameter("density", 0.3 * look.fog)
	_fog.set_shader_parameter("fog_color", look.fog_color)
	RenderingServer.global_shader_parameter_set("wind", look.wind + quake)
	var settle := 60.0 if kind == Kind.SNOW else 90.0
	snow_cover = move_toward(snow_cover, 0.85 if kind == Kind.SNOW else 0.0, delta / settle)
	_cover.set_shader_parameter("coverage", snow_cover)
	# the falling particles follow the view
	var center := _player.camera.get_screen_center_position()
	for list: Array in _emitters.values():
		for emitter: CPUParticles2D in list:
			emitter.global_position = center
			emitter.visible = not underground


func _pick() -> Kind:
	var total := 0.0
	for k: Kind in CHANCES:
		total += CHANCES[k]
	var roll := randf() * total
	for k: Kind in CHANCES:
		roll -= CHANCES[k]
		if roll <= 0.0:
			return k
	return Kind.CLEAR


func _build_emitters() -> void:
	var streak := load("res://assets/rain.png")
	var ash_embers := CanvasItemMaterial.new()
	ash_embers.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	ash_embers.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	_emitters = {
		Kind.RAIN: [_emitter(streak, 360, 0.8, Vector2(0.18, 1), 420.0, 520.0, Color(1, 1, 1, 0.5)), _splashes(80)],
		Kind.HEAVY_RAIN: [_emitter(streak, 720, 0.7, Vector2(0.3, 1), 520.0, 640.0, Color(1, 1, 1, 0.6)), _splashes(170)],
		Kind.SNOW: [_emitter(null, 280, 9.0, Vector2(0.2, 1), 14.0, 30.0, Color(0.92, 0.95, 1.0), 2.0)],
		Kind.ASH: [_emitter(null, 240, 9.0, Vector2(0.35, 1), 10.0, 22.0, Color(0.5, 0.47, 0.45), 2.0),
			_emitter(null, 24, 6.0, Vector2(0.3, 1), 8.0, 16.0, Color(1.0, 0.55, 0.2), 1.0, ash_embers)],
		Kind.CLEAR: [],
	}


func _emitter(texture: Texture2D, amount: int, lifetime: float, direction: Vector2, speed_min: float, speed_max: float,
		color: Color, max_scale := 1.0, material: Material = null) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.texture = texture
	p.emitting = false
	p.amount = amount
	p.lifetime = lifetime
	p.local_coords = false
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(720, 440)
	p.direction = direction
	p.spread = 4.0 if texture else 25.0
	p.gravity = Vector2.ZERO
	p.initial_velocity_min = speed_min
	p.initial_velocity_max = speed_max
	p.scale_amount_max = max_scale
	p.color = color
	p.z_index = 50
	if material == null:
		material = CanvasItemMaterial.new()
		material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	p.material = material
	add_child(p)
	return p


func _splashes(amount: int) -> CPUParticles2D:
	var p := _emitter(null, amount, 0.22, Vector2(0, -1), 10.0, 25.0, Color(0.7, 0.8, 0.9, 0.7))
	p.spread = 60.0
	p.gravity = Vector2(0, 120)
	p.emission_rect_extents = Vector2(660, 380)
	return p
