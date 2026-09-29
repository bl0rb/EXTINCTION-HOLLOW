extends Node2D
## Combat overlay in world space, above the night darkness (GAME_SPEC §150):
## health bars over wounded animals, items on the ground compared with what the dino wears, floating combat text (see Fx.text).

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")

@onready var player: Player = get_tree().get_first_node_in_group("player")


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
	# every item on the ground shows at a glance whether it beats what is worn; the one under the cursor tells by how much
	var mouse := get_global_mouse_position()
	var hovered: Node2D
	for drop: Node2D in get_tree().get_nodes_in_group("loot"):
		Loot.draw_arrow(self, drop.global_position + Vector2(7, -15), Loot.verdict(drop.item, player.equipped[drop.item.slot]))
		if drop.global_position.distance_to(mouse) < 12.0:
			hovered = drop
	if hovered:
		_item_label(hovered)


## The item's name and what wearing it would change against the worn item.
func _item_label(drop: Node2D) -> void:
	var item: Dictionary = drop.item
	var worn: Dictionary = player.equipped[item.slot]
	var lines := [[item.name, Loot.COLORS[item.rarity]]]
	if worn.is_empty():
		lines.append(["NEW " + Loot.SLOT_NAMES[item.slot].to_upper(), Loot.BETTER])
	else:
		var diff := Loot.compare(item, worn)
		for id: String in diff:
			if diff[id] != 0:
				lines.append([Loot.change_text(id, diff[id]), Loot.BETTER if diff[id] > 0 else Loot.WORSE])
	if player.bag.size() >= Player.BAG_SIZE:
		lines.append(["BAG FULL", Fx.HURT])
	var width := 0.0
	for line: Array in lines:
		width = maxf(width, FONT.get_string_size(line[0], HORIZONTAL_ALIGNMENT_LEFT, -1, 8).x)
	var top := (drop.global_position + Vector2(0, -18 - 9 * lines.size())).round()
	draw_rect(Rect2(top + Vector2(-width / 2.0 - 3.0, -1), Vector2(width + 6.0, 9 * lines.size() + 3)).abs(), Color(0.02, 0.02, 0.03, 0.75))
	for i in lines.size():
		draw_string(FONT, top + Vector2(-60, 8 + 9 * i), lines[i][0], HORIZONTAL_ALIGNMENT_CENTER, 120, 8, lines[i][1])
