extends Area2D
## Lava pool in the volcano region (GAME_SPEC §29): glows and burns whoever steps in.

const DAMAGE := 25.0 ## per second


func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.burn(DAMAGE * delta)
