class_name Fish
extends Prey
## Fish in a pond (GAME_SPEC §26): swims around and darts away from a player walking close.
## A player standing still at the shore can snap a fish that comes near.

@onready var pond: Pond = get_parent()


func _physics_process(delta: float) -> void:
	var away := global_position - player.global_position
	var alarmed := not player.dead and away.length() < species.fear_radius and player.velocity.length() > 10.0
	if alarmed:
		state = State.FLEE
	elif state == State.FLEE and away.length() > species.calm_radius:
		_rest()

	var speed := species.speed
	if state == State.FLEE:
		target = pond.clamp_point(global_position + away.normalized() * 24.0)
		speed = species.flee_speed
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			_stand(delta)
			return
		target = pond.random_point()
		state = State.WANDER

	# fish swim freely inside the pond, without physics, but with the same inertia
	var to_target := target - global_position
	var desired := to_target.normalized() * speed * clampf(to_target.length() / 10.0, 0.3, 1.0)
	velocity = velocity.move_toward(desired, species.acceleration * delta)
	_animate(velocity, velocity.length() * delta / species.stride, delta)
	if to_target.length() <= maxf(velocity.length() * delta, 0.5):
		global_position = target
		velocity = Vector2.ZERO
		if state == State.WANDER:
			_rest()
	else:
		global_position += velocity * delta
