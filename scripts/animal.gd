class_name Animal
extends CharacterBody2D
## Shared behaviour of NPC animals: species data, walking with inertia, turning around, walk and idle animation.

@export var species: Species

var target := Vector2.ZERO
var anim := SpriteAnimator.new()
var _panic_from := Vector2.ZERO
var _panic_left := 0.0

@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Player = get_tree().get_first_node_in_group("player")


## Size class (GAME_SPEC §8): animals only eat what is smaller than themselves.
func get_size() -> int:
	return species.size


## Disasters (GAME_SPEC §39): run away from a spot for a while, whatever else is going on.
func panic(from: Vector2, seconds: float) -> void:
	_panic_from = from
	_panic_left = seconds


## Runs away while panicking; returns false once calm again.
func _flee_in_panic(speed: float, delta: float) -> bool:
	if _panic_left <= 0.0:
		return false
	_panic_left -= delta
	target = global_position + (global_position - _panic_from).normalized() * 32.0
	_walk(speed, delta)
	return true


## Walks towards target, speeding up and easing into it.
## Returns true once it is reached or the way is (mostly) blocked.
func _walk(speed: float, delta: float) -> bool:
	var to_target := target - global_position
	var dist := to_target.length()
	var desired := to_target.normalized() * speed * clampf(dist / 10.0, 0.3, 1.0)
	# brake harder when turning back, and face the way the animal really moves
	velocity = velocity.move_toward(desired, species.acceleration * (2.0 if velocity.dot(desired) < 0.0 else 1.0) * delta)
	_animate(velocity, velocity.length() * delta / species.stride, delta)
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


func _animate(direction: Vector2, steps: float, delta: float) -> void:
	anim.update(sprite, direction, steps, delta)
