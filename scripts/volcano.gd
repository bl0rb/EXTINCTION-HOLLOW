class_name Volcano
extends Node2D
## The volcano in the north-east (GAME_SPEC §29, §37, §149.18): smokes and glows, rumbles and glows brighter
## before an eruption, erupts with fountains of embers. Its lava is a light source and burns. It roars and bubbles (T098).

enum { CALM, WARNING, ERUPTING }

const CRATER_HEIGHT := 172.0 ## crater height above the cone's base
const LAVA_DAMAGE := 25.0 ## per second

var activity := CALM
var _rumble: AudioStreamPlayer2D

@onready var heavy_smoke: CPUParticles2D = $HeavySmoke
@onready var fountain: CPUParticles2D = $Fountain
@onready var crater_glow: Flicker = $CraterGlow
@onready var lava: Sprite2D = $Lava
@onready var hazard: Area2D = $LavaHazard


func _ready() -> void:
	var player := AudioStreamPlayer2D.new()
	player.position = Vector2(0, -60)
	player.max_distance = 900.0
	_rumble = Sound.loop(self, "volcano", player)


func set_activity(level: int) -> void:
	if level == ERUPTING and activity != ERUPTING:
		Sound.play(self, "eruption", global_position + Vector2(0, -CRATER_HEIGHT), 4.0, 1.0, 2400.0)
	activity = level
	heavy_smoke.emitting = level != CALM
	fountain.emitting = level == ERUPTING
	crater_glow.intensity = [1.0, 1.7, 2.8][level]
	(lava.material as ShaderMaterial).set_shader_parameter("activity", [1.0, 1.2, 1.45][level])


func _physics_process(delta: float) -> void:
	Sound.fade(_rumble, [0.6, 0.85, 1.0][activity], delta)
	for body in hazard.get_overlapping_bodies():
		if body is Player:
			body.burn(LAVA_DAMAGE * delta)
