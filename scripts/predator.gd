class_name Predator
extends Animal
## Large predator: wanders, hunts smaller animals and the player on sight, bites. Slower than the player.

enum State { IDLE, WANDER, CHASE }

const EYES_CALM := Color(0.7, 0.6, 0.4)
const EYES_HUNTING := Color(1.6, 0.8, 0.5)
const DIGEST_TIME := 3.0 ## idle time multiplier after eating
const FIRE_FEAR := 70.0 ## keeps this far away from fire

var state := State.IDLE
var timer := 0.0
var victim: Node2D
var _cooldown := 0.0
var _provoked := 0.0 ## seconds it keeps going for the player who bit it, whatever their size
var _roared := 0.0 ## seconds until it roars again

@onready var eyes: Sprite2D = $Sprite2D/Eyes
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")


func _ready() -> void:
	_vary()
	_rest()


func _rest(duration := 1.0) -> void:
	state = State.IDLE
	victim = null
	timer = species.idle_time * (0.5 + randf()) * duration
	eyes.modulate = EYES_CALM


## Untyped on purpose: the victim may have been eaten (freed) by someone else.
func _can_hunt(animal) -> bool:
	if not is_instance_valid(animal):
		return false
	if animal == player:
		# the cave is a safe place
		return not player.dead and (player.get_size() < get_size() or _provoked > 0.0 or hostile) and not cave.overlaps_body(player)
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


func _hurt(_from: Node2D) -> void:
	_provoked = 6.0
	victim = player
	_roar()
	state = State.CHASE
	eyes.modulate = EYES_HUNTING


func _physics_process(delta: float) -> void:
	_cooldown -= delta
	_provoked -= delta
	_roared -= delta
	for fire: Node2D in get_tree().get_nodes_in_group("fire"):
		if fire.global_position.distance_to(global_position) < FIRE_FEAR:
			panic(fire.global_position, 1.5)
	if _flee_in_panic(species.chase_speed, delta):
		if state == State.CHASE:
			_rest()
		return
	if state != State.CHASE:
		victim = _find_victim()
		if victim:
			state = State.CHASE
			eyes.modulate = EYES_HUNTING
			if victim == player:
				_roar()
	elif not _can_hunt(victim) or global_position.distance_to(victim.global_position) > species.vision_radius * 1.7:
		_rest()

	var speed := species.speed
	if state == State.CHASE:
		target = victim.global_position
		speed = species.chase_speed
		if global_position.distance_to(target) <= species.attack_range:
			velocity = Vector2.ZERO
			_animate(target - global_position, 0.0, delta)
			if _cooldown <= 0.0:
				_cooldown = species.attack_interval
				_bite()
			return
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			_stand(delta)
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


## The hunt starts with a roar (T096); smaller hunters screech higher.
func _roar() -> void:
	if _roared <= 0.0:
		_roared = 8.0
		Sound.play(get_parent(), "roar", global_position, -3.0, 1.9 - 0.25 * species.size, 700.0)


func _bite() -> void:
	anim.play("attack", 0.22)
	Sound.play(get_parent(), "bite", global_position, -2.0, 0.8)
	if victim == player:
		player.take_damage(species.damage * power)
	else:
		Fx.burst(Fx.BLOOD, get_parent(), victim.global_position + Vector2(0, -4))
		victim.queue_free()
		anim.then("eat", 1.4)
		_rest(DIGEST_TIME)


func _animate(direction: Vector2, steps: float, delta: float) -> void:
	super(direction, steps, delta)
	eyes.frame = sprite.frame # the eyes turn with the sprite they belong to
