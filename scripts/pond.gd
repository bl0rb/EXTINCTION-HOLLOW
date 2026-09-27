class_name Pond
extends Sprite2D
## Water area fish live in (GAME_SPEC §25).

@export var swim_radius := Vector2(100, 42) ## ellipse the fish stay inside, around the pond centre


func clamp_point(point: Vector2) -> Vector2:
	return global_position + ((point - global_position) / swim_radius).limit_length(1.0) * swim_radius


func random_point() -> Vector2:
	return global_position + Vector2.from_angle(randf() * TAU) * sqrt(randf()) * swim_radius
