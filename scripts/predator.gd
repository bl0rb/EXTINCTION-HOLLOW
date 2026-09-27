class_name Predator
extends CharacterBody2D
## Large predator: wanders, chases the player on sight and bites. Slower than the player, so it can be outrun.

enum State { IDLE, WANDER, CHASE }

const EYES_CALM := Color(0.7, 0.6, 0.4)
const EYES_HUNTING := Color(1.6, 0.8, 0.5)

@export var species: Species

var state := State.IDLE
var target := Vector2.ZERO
var timer := 0.0
var _cooldown := 0.0
var _step := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var eyes: Sprite2D = $Sprite2D/Eyes
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")


func _ready() -> void:
	_rest()


func _rest() -> void:
	state = State.IDLE
	timer = species.idle_time * (0.5 + randf())
	eyes.modulate = EYES_CALM


func _can_hunt() -> bool:
	# the cave is a safe place
	return not player.dead and not cave.overlaps_body(player)


func _physics_process(delta: float) -> void:
	_cooldown -= delta
	var dist := global_position.distance_to(player.global_position)
	if state != State.CHASE and dist < species.vision_radius and _can_hunt():
		state = State.CHASE
		eyes.modulate = EYES_HUNTING
	elif state == State.CHASE and (dist > species.vision_radius * 1.7 or not _can_hunt()):
		_rest()

	var speed := species.speed
	if state == State.CHASE:
		target = player.global_position
		speed = species.chase_speed
		if dist <= species.attack_range:
			if _cooldown <= 0.0:
				_cooldown = species.attack_interval
				player.take_damage(species.damage)
			_animate(target - global_position, 0.0)
			return
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			sprite.frame = 0
			eyes.frame = 0
			return
		target = global_position + Vector2.from_angle(randf() * TAU) * randf() * species.wander_radius
		state = State.WANDER

	var to_target := target - global_position
	_animate(to_target, delta * speed * 0.12)
	var arrived := to_target.length() <= speed * delta
	velocity = to_target / delta if arrived else to_target.normalized() * speed
	var before := global_position
	move_and_slide()
	if state == State.CHASE and global_position.distance_to(before) < speed * delta * 0.3:
		# blocked head-on: sidestep around the obstacle
		velocity = to_target.normalized().rotated(PI / 2.5) * speed
		move_and_slide()
	if state == State.WANDER and (arrived or global_position.distance_to(before) < 0.01):
		_rest()


func _animate(direction: Vector2, steps: float) -> void:
	if absf(direction.x) > 0.5:
		sprite.flip_h = direction.x < 0.0
		eyes.flip_h = sprite.flip_h
	_step += steps
	sprite.frame = int(_step) % 2
	eyes.frame = sprite.frame
