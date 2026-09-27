class_name GameCamera
extends Camera2D
## Follows the player via position smoothing and zooms with the mouse wheel.

# with the default 1280x720 window these steps keep integer pixel scales (1x to 4x)
const ZOOM_MIN := 0.5
const ZOOM_MAX := 2.0
const ZOOM_STEP := 0.5

var _shake := 0.0
var _shake_time := 0.0


func shake(strength: float, duration: float) -> void:
	_shake = strength
	_shake_time = duration


func _process(delta: float) -> void:
	_shake_time -= delta
	# whole-pixel offsets keep the pixel art crisp
	offset = Vector2(randf_range(-_shake, _shake), randf_range(-_shake, _shake)).round() if _shake_time > 0.0 else Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom = Vector2.ONE * minf(zoom.x + ZOOM_STEP, ZOOM_MAX)
	elif event.is_action_pressed("zoom_out"):
		zoom = Vector2.ONE * maxf(zoom.x - ZOOM_STEP, ZOOM_MIN)
