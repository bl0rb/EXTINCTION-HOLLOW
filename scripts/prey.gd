class_name Prey
extends Animal
## Small prey animal: idles, wanders and flees from bigger hunters.

enum State { IDLE, WANDER, FLEE }

var state := State.IDLE
var timer := 0.0
var _threat: Node2D
var _home: Vector2 ## animals roam around where they were born, so every region keeps its own wildlife
var _cooldown := 0.0


func _ready() -> void:
	_home = global_position
	_vary()
	anim.set_facing(-1.0 if randf() < 0.5 else 1.0)
	_rest()


func _rest() -> void:
	state = State.IDLE
	timer = species.idle_time * (0.5 + randf())


## Nearest threat inside the fear radius: bigger hunters (predators, the player) and fire.
func _find_threat() -> Node2D:
	var best: Node2D = null
	var best_dist := species.fear_radius
	var hunters := get_tree().get_nodes_in_group("predator") + get_tree().get_nodes_in_group("fire")
	if not player.dead:
		hunters.append(player)
	for hunter in hunters:
		var dist := global_position.distance_to(hunter.global_position)
		if hunter.get_size() > get_size() and dist < best_dist:
			best = hunter
			best_dist = dist
	return best


func _physics_process(delta: float) -> void:
	if _flee_in_panic(species.flee_speed, delta):
		state = State.FLEE
		return
	var threat := _find_threat()
	if threat:
		_threat = threat
		state = State.FLEE
	elif state == State.FLEE and (not is_instance_valid(_threat) or global_position.distance_to(_threat.global_position) > species.calm_radius):
		_rest()

	# armoured prey hits back at a hunter that comes too close (GAME_SPEC §29: dangerous prey)
	_cooldown -= delta
	if state == State.FLEE and species.damage > 0.0 and _threat == player and _cooldown <= 0.0 \
			and global_position.distance_to(player.global_position) < species.attack_range + radius:
		_cooldown = species.attack_interval
		player.take_damage(species.damage * power)

	var speed := species.speed
	if state == State.FLEE:
		# run straight away from the threat
		target = global_position + (global_position - _threat.global_position).normalized() * 32.0
		speed = species.flee_speed
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			_stand(delta)
			return
		target = _home + Vector2.from_angle(randf() * TAU) * randf() * species.wander_radius
		state = State.WANDER

	if _walk(speed, delta) and state == State.WANDER:
		_rest()
