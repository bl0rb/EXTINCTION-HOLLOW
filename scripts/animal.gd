class_name Animal
extends CharacterBody2D
## Shared behaviour of NPC animals: species data, walking with inertia, turning around, walk and idle animation.

@export var species: Species

var target := Vector2.ZERO
var anim := SpriteAnimator.new()
var health := 1.0
var max_health := 1.0
var bar_time := 0.0 ## seconds the health bar stays visible after a hit
var _panic_from := Vector2.ZERO
var _panic_left := 0.0

@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Player = get_tree().get_first_node_in_group("player")


func _enter_tree() -> void:
	max_health = species.health
	health = max_health


## Takes a bite (GAME_SPEC §150): shows the damage, flashes and dies at zero health. Returns true on death.
func hit(amount: float, from: Node2D, crit := false) -> bool:
	health -= amount
	bar_time = 4.0
	Fx.number(self, sprite.global_position + Vector2(0, -10), amount, Fx.WHITE, crit)
	sprite.modulate = Color(1.8, 0.7, 0.6)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.2)
	if health <= 0.0:
		queue_free()
		return true
	_hurt(from)
	return false


## A wounded animal runs for it; predators fight back instead.
func _hurt(from: Node2D) -> void:
	panic(from.global_position, 2.0)


## No two animals look quite alike: a little bigger or smaller, a slightly different colour.
func _vary() -> void:
	var s := randf_range(0.88, 1.14)
	sprite.scale = Vector2(s, s)
	sprite.self_modulate = Color(randf_range(0.86, 1.1), randf_range(0.86, 1.08), randf_range(0.86, 1.08))


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
