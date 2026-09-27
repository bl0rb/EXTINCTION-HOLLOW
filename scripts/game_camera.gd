extends Camera2D
## Follows the player via position smoothing and zooms with the mouse wheel.

# with the default 1280x720 window these steps keep integer pixel scales (1x to 4x)
const ZOOM_MIN := 0.5
const ZOOM_MAX := 2.0
const ZOOM_STEP := 0.5


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom = Vector2.ONE * minf(zoom.x + ZOOM_STEP, ZOOM_MAX)
	elif event.is_action_pressed("zoom_out"):
		zoom = Vector2.ONE * maxf(zoom.x - ZOOM_STEP, ZOOM_MIN)
