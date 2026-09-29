class_name SpriteAnimator
extends RefCounted
## Frames and facing for the 3/4 creature sheets: 0-1 idle breathing, 2-5 walk cycle, 6-7 eat, 8-9 attack.
## Turning around squeezes the sprite through its side view instead of flipping instantly.

const TURN_TIME := 0.13 ## seconds to turn around
const BREATH_TIME := 0.7 ## seconds per idle frame
const CHEW_TIME := 0.16 ## seconds per eat frame

var facing := 1.0
var _turn := 1.0
var _step := 0.0
var _idle := 0.0
var _queue: Array = [] ## [action, seconds] pairs, played in order
var _action_time := 0.0


func set_facing(direction: float) -> void:
	facing = direction
	_turn = direction


## A quick turn on the spot, e.g. for a tail sweep: from facing away back to the front.
func spin() -> void:
	_turn = -facing


## Plays "attack" or "eat" right away, dropping anything queued.
func play(action: String, seconds: float) -> void:
	_queue = [[action, seconds]]
	_action_time = 0.0


## Plays an action after the current ones.
func then(action: String, seconds: float) -> void:
	_queue.append([action, seconds])


func busy() -> bool:
	return not _queue.is_empty()


## direction: the way the creature actually moves (its velocity) or looks; mostly vertical moves keep the facing.
func update(sprite: Sprite2D, direction: Vector2, steps: float, delta: float) -> void:
	if absf(direction.x) > 4.0 and absf(direction.x) > direction.length() * 0.25:
		facing = signf(direction.x)
	_turn = move_toward(_turn, facing, delta * 2.0 / TURN_TIME)
	sprite.scale.x = absf(sprite.scale.y) * (signf(_turn) if _turn != 0.0 else facing) * maxf(absf(_turn), 0.2)
	if busy():
		var seconds: float = _queue[0][1]
		_action_time += delta
		if _queue[0][0] == "attack":
			sprite.frame = 8 + mini(int(_action_time / seconds * 2.0), 1)
		else:
			sprite.frame = 6 + int(_action_time / CHEW_TIME) % 2
		if _action_time >= seconds:
			_queue.pop_front()
			_action_time = 0.0
	elif steps > 0.0:
		_step += steps
		_idle = 0.0
		sprite.frame = 2 + int(_step) % 4
	else:
		_idle += delta
		sprite.frame = int(_idle / BREATH_TIME) % 2
