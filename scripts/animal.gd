class_name Animal
extends CharacterBody2D
## Shared behaviour of NPC animals: species data, walking with collision, facing and walk frames.

@export var species: Species

var target := Vector2.ZERO
var _step := 0.0

@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Player = get_tree().get_first_node_in_group("player")


## Size class (GAME_SPEC §8): animals only eat what is smaller than themselves.
func get_size() -> int:
	return species.size


## Walks towards target. Returns true once it is reached or the way is (mostly) blocked.
func _walk(speed: float, delta: float) -> bool:
	var to_target := target - global_position
	_animate(to_target, speed * delta / species.stride)
	var arrived := to_target.length() <= speed * delta
	velocity = to_target / delta if arrived else to_target.normalized() * speed
	var before := global_position
	move_and_slide()
	return arrived or global_position.distance_to(before) < speed * delta * 0.3


## 3/4 view: face left or right and alternate the walk frames.
func _animate(direction: Vector2, steps: float) -> void:
	if absf(direction.x) > 0.5:
		sprite.flip_h = direction.x < 0.0
	_step += steps
	sprite.frame = int(_step) % 2
