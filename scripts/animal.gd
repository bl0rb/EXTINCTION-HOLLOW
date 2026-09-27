class_name Animal
extends CharacterBody2D
## Shared behaviour of NPC animals: species data, walking with inertia, turning around, walk and idle animation.

@export var species: Species

var target := Vector2.ZERO
var anim := SpriteAnimator.new()

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


func _animate(direction: Vector2, steps: float, delta: float) -> void:
	anim.update(sprite, direction, steps, delta)
