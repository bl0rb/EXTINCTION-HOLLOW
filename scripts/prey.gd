class_name Prey
extends Animal
## Small prey animal: idles, wanders and flees from bigger hunters.

enum State { IDLE, WANDER, FLEE }

var state := State.IDLE
var timer := 0.0
var _threat: Node2D


func _ready() -> void:
	sprite.flip_h = randf() < 0.5
	_rest()


func _rest() -> void:
	state = State.IDLE
	timer = species.idle_time * (0.5 + randf())


## Nearest bigger hunter (predators or the player) inside the fear radius.
func _find_threat() -> Node2D:
	var best: Node2D = null
	var best_dist := species.fear_radius
	var hunters := get_tree().get_nodes_in_group("predator")
	if not player.dead:
		hunters.append(player)
	for hunter in hunters:
		var dist := global_position.distance_to(hunter.global_position)
		if hunter.get_size() > get_size() and dist < best_dist:
			best = hunter
			best_dist = dist
	return best


func _physics_process(delta: float) -> void:
	var threat := _find_threat()
	if threat:
		_threat = threat
		state = State.FLEE
	elif state == State.FLEE and (not is_instance_valid(_threat) or global_position.distance_to(_threat.global_position) > species.calm_radius):
		_rest()

	var speed := species.speed
	if state == State.FLEE:
		# run straight away from the threat
		target = global_position + (global_position - _threat.global_position).normalized() * 32.0
		speed = species.flee_speed
	elif state == State.IDLE:
		timer -= delta
		if timer > 0.0:
			sprite.frame = 0
			return
		target = global_position + Vector2.from_angle(randf() * TAU) * randf() * species.wander_radius
		state = State.WANDER

	if _walk(speed, delta) and state == State.WANDER:
		_rest()
