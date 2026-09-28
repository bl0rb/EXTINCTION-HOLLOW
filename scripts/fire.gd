class_name Fire
extends Area2D
## A burning spot (GAME_SPEC §38, §149.17): flames, glow, sparks and smoke. Hurts whoever stands in it,
## scares animals and burns out after a while, faster in the rain.

@export var burn_time := 30.0
@export var damage_per_second := 16.0

var _age := 0.0

@onready var flames: Sprite2D = $Flames
@onready var glow: Flicker = $Light
@onready var _weather: Weather = get_tree().get_first_node_in_group("weather")


## Everything is afraid of fire.
func get_size() -> int:
	return 99


func _physics_process(delta: float) -> void:
	var rain := _weather != null and _weather.kind in [Weather.Kind.RAIN, Weather.Kind.HEAVY_RAIN]
	_age += delta * (2.5 if rain else 1.0)
	flames.frame = int(_age * 10.0) % 4
	var strength := clampf((burn_time - _age) / 4.0, 0.0, 1.0)
	flames.scale = Vector2.ONE * (0.4 + 0.6 * strength) * Art.SCALE
	glow.intensity = strength
	for body in get_overlapping_bodies():
		if body is Player:
			body.burn(damage_per_second * delta)
	if _age >= burn_time:
		queue_free()
