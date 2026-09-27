class_name Animal
extends CharacterBody2D
## Shared behaviour of NPC animals: species data, walking with inertia, turning around, walk and idle animation.

const TURN_TIME := 0.14 ## seconds to turn around
const BREATH_TIME := 0.7 ## seconds per idle breathing frame

@export var species: Species

var target := Vector2.ZERO
var _step := 0.0
var _idle := 0.0
var _facing := 1.0
var _turn := 1.0

@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Player = get_tree().get_first_node_in_group("player")


## Size class (GAME_SPEC §8): animals only eat what is smaller than themselves.
func get_size() -> int:
	return species.size


## Walks towards target, speeding up and easing into it.
## Returns true once it is reached or the way is (mostly) blocked.
func _walk(speed: float, delta: float) -> bool:
	var to_target := target - global_position
	var dist := to_target.length()
	var desired := to_target.normalized() * speed * clampf(dist / 10.0, 0.3, 1.0)
	velocity = velocity.move_toward(desired, species.acceleration * delta)
	_animate(to_target, velocity.length() * delta / species.stride, delta)
	if dist <= maxf(velocity.length() * delta, 0.5):
		velocity = to_target / delta
		move_and_slide()
		velocity = Vector2.ZERO
		return true
	var expected := velocity.length() * delta
	var before := global_position
	move_and_slide()
	return global_position.distance_to(before) < expected * 0.3


## Standing still: breathe and finish turning around.
func _stand(delta: float) -> void:
	velocity = Vector2.ZERO
	_animate(Vector2.ZERO, 0.0, delta)


## 3/4 view: turning squeezes the sprite through its side view; frames 0-1 breathe, 2-5 walk.
func _animate(direction: Vector2, steps: float, delta: float) -> void:
	if absf(direction.x) > 0.5:
		_facing = signf(direction.x)
	_turn = move_toward(_turn, _facing, delta * 2.0 / TURN_TIME)
	sprite.scale.x = absf(sprite.scale.y) * (signf(_turn) if _turn != 0.0 else _facing) * maxf(absf(_turn), 0.2)
	if steps > 0.0:
		_step += steps
		_idle = 0.0
		sprite.frame = 2 + int(_step) % 4
	else:
		_idle += delta
		sprite.frame = int(_idle / BREATH_TIME) % 2
