class_name Predator
extends Animal
## Large predator: wanders, hunts smaller animals and the player on sight, bites. Slower than the player.

enum State { IDLE, WANDER, CHASE }

const EYES_CALM := Color(0.7, 0.6, 0.4)
const EYES_HUNTING := Color(1.6, 0.8, 0.5)
const DIGEST_TIME := 3.0 ## idle time multiplier after eating

var state := State.IDLE
var timer := 0.0
var victim: Node2D
var _cooldown := 0.0

@onready var eyes: Sprite2D = $Sprite2D/Eyes
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")


func _ready() -> void:
	_rest()


func _rest(duration := 1.0) -> void:
	state = State.IDLE
	victim = null
	timer = species.idle_time * (0.5 + randf()) * duration
	eyes.modulate = EYES_CALM


func _can_hunt(animal: Node2D) -> bool:
	if not is_instance_valid(animal):
		return false
	if animal == player:
		# the cave is a safe place
		return not player.dead and player.get_size() < get_size() and not cave.overlaps_body(player)
	return animal is Prey and not animal is Fish and animal.get_size() < get_size()


func _find_victim() -> Node2D:
	var best: Node2D = null
	var best_dist := species.vision_radius
	var candidates := get_tree().get_nodes_in_group("prey")
	candidates.append(player)
	for animal in candidates:
		var dist := global_position.distance_to(animal.global_position)
		if dist < best_dist and _can_hunt(animal):
			best = animal
			best_dist = dist
	return best


func _physics_process(delta: float) -> void:
	_cooldown -= delta
	if state != State.CHASE:
		victim = _find_victim()
		if victim:
			state = State.CHASE
			eyes.modulate = EYES_HUNTING
	elif not _can_hunt(victim) or global_position.distance_to(victim.global_position) > species.vision_radius * 1.7:
		_rest()

	var speed := species.speed
	if state == State.CHASE:
		target = victim.global_position
		speed = species.chase_speed
		if global_position.distance_to(target) <= species.attack_range:
			_animate(target - global_position, 0.0)
			if _cooldown <= 0.0:
				_cooldown = species.attack_interval
				_bite()
			return
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			_animate(Vector2.ZERO, 0.0)
			sprite.frame = 0
			eyes.frame = 0
			return
		target = global_position + Vector2.from_angle(randf() * TAU) * randf() * species.wander_radius
		state = State.WANDER

	if _walk(speed, delta):
		if state == State.WANDER:
			_rest()
		elif state == State.CHASE:
			# blocked head-on: sidestep around the obstacle
			velocity = (target - global_position).normalized().rotated(PI / 2.5) * speed
			move_and_slide()


func _bite() -> void:
	if victim == player:
		player.take_damage(species.damage)
	else:
		victim.queue_free()
		_rest(DIGEST_TIME)


func _animate(direction: Vector2, steps: float) -> void:
	super(direction, steps)
	eyes.flip_h = sprite.flip_h
	eyes.frame = sprite.frame
