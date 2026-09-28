extends Node2D
## Combat overlay in world space, above the night darkness (GAME_SPEC §150):
## health bars over wounded animals, item names under the cursor, floating combat text (see Fx.text).

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")


func _process(delta: float) -> void:
	for animal: Animal in _animals():
		animal.bar_time = maxf(animal.bar_time - delta, 0.0)
	queue_redraw()


func _animals() -> Array:
	return get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator")


func _draw() -> void:
	for animal: Animal in _animals():
		if animal.bar_time <= 0.0 or animal.health >= animal.max_health:
			continue
		var alpha := clampf(animal.bar_time, 0.0, 1.0)
		var width := roundf(10.0 + 6.0 * animal.get_size())
		var height := animal.sprite.get_rect().size.y * absf(animal.sprite.scale.y)
		var pos := (animal.sprite.global_position - Vector2(width / 2.0, height / 2.0 + 5.0)).round()
		draw_rect(Rect2(pos, Vector2(width, 3)), Color(0.02, 0.02, 0.03, 0.8 * alpha))
		draw_rect(Rect2(pos + Vector2.ONE, Vector2(roundf((width - 2.0) * animal.health / animal.max_health), 1)), Color(0.9, 0.22, 0.16, alpha))
	# elites and bosses carry their title
	for animal: Animal in _animals():
		if animal.title != "" and animal.global_position.distance_to(get_viewport().get_camera_2d().get_screen_center_position()) < 400.0:
			var height := animal.sprite.get_rect().size.y * absf(animal.sprite.scale.y)
			draw_string(FONT, (animal.sprite.global_position - Vector2(60, height / 2.0 + 8.0)).round(), animal.title, HORIZONTAL_ALIGNMENT_CENTER, 120, 8,
				Fx.CRIT if animal.rank == 1 else Fx.HURT)
	var mouse := get_global_mouse_position()
	for drop: Node2D in get_tree().get_nodes_in_group("loot"):
		if drop.global_position.distance_to(mouse) < 12.0:
			draw_string(FONT, (drop.global_position + Vector2(-60, -16)).round(), drop.item.name, HORIZONTAL_ALIGNMENT_CENTER, 120, 8, Loot.COLORS[drop.item.rarity])
