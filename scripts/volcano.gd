class_name Volcano
extends Node2D
## The volcano in the north-east (GAME_SPEC §29, §37, §149.18): smokes and glows, rumbles and glows brighter
## before an eruption, erupts with fountains of embers. Its lava is a light source and burns.

enum { CALM, WARNING, ERUPTING }

const CRATER_HEIGHT := 172.0 ## crater height above the cone's base
const LAVA_DAMAGE := 25.0 ## per second

var activity := CALM

@onready var heavy_smoke: CPUParticles2D = $HeavySmoke
@onready var fountain: CPUParticles2D = $Fountain
@onready var crater_glow: Flicker = $CraterGlow
@onready var lava: Sprite2D = $Lava
@onready var hazard: Area2D = $LavaHazard


func set_activity(level: int) -> void:
	activity = level
	heavy_smoke.emitting = level != CALM
	fountain.emitting = level == ERUPTING
	crater_glow.intensity = [1.0, 1.7, 2.8][level]
	(lava.material as ShaderMaterial).set_shader_parameter("activity", [1.0, 1.2, 1.45][level])


func _physics_process(delta: float) -> void:
	for body in hazard.get_overlapping_bodies():
		if body is Player:
			body.burn(LAVA_DAMAGE * delta)
