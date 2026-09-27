class_name River
extends Pond
## The river (GAME_SPEC §27, §114): fish swim anywhere along its open water, from the swamp to the ice.

@export var length := 2300.0 ## open water from x = 0 on, frozen beyond


func clamp_point(point: Vector2) -> Vector2:
	var x := clampf(point.x, 10.0, length - 10.0)
	var half := Biomes.river_half(x) - 6.0
	return Vector2(x, clampf(point.y, Biomes.river_y(x) - half, Biomes.river_y(x) + half))


func random_point() -> Vector2:
	var x := randf_range(20.0, length - 20.0)
	return Vector2(x, Biomes.river_y(x) + randf_range(-1.0, 1.0) * (Biomes.river_half(x) - 8.0))
