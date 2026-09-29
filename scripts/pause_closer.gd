extends Node
## While the game is paused, Esc resumes it (the HUD itself is paused then).


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and get_tree().paused:
		get_viewport().set_input_as_handled()
		get_tree().get_first_node_in_group("hud").resume()
