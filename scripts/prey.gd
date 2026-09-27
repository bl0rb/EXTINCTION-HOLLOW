class_name Prey
extends CharacterBody2D
## Small prey animal: idles, wanders and flees from the player.

enum State { IDLE, WANDER, FLEE }

@export var species: Species

var state := State.IDLE
var target := Vector2.ZERO
var timer := 0.0

@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	sprite.rotation = randf() * TAU
	_rest()


func _rest() -> void:
	state = State.IDLE
	timer = species.idle_time * (0.5 + randf())


func _physics_process(delta: float) -> void:
	var away := global_position - player.global_position
	var dist := away.length()
	if dist < species.fear_radius:
		state = State.FLEE
	elif state == State.FLEE and dist > species.calm_radius:
		_rest()

	var speed := species.speed
	if state == State.FLEE:
		# run straight away from the player
		target = global_position + away.normalized() * 32.0
		speed = species.flee_speed
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			return
		target = global_position + Vector2.from_angle(randf() * TAU) * randf() * species.wander_radius
		state = State.WANDER

	var to_target := target - global_position
	sprite.rotation = rotate_toward(sprite.rotation, to_target.angle(), species.turn_speed * delta)
	var arrived := to_target.length() <= speed * delta
	velocity = to_target / delta if arrived else to_target.normalized() * speed
	var before := global_position
	move_and_slide()
	if state == State.WANDER and (arrived or global_position.distance_to(before) < 0.01):
		_rest()
