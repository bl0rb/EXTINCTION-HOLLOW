extends Control
## Inventory (GAME_SPEC §150): the four trophy slots and the bag.
## Click wears an item or takes it off, right click salvages it for XP.

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")
const ICONS := preload("res://assets/items.png")
const CELL := 20
const COLS := 6
const TEXT := Color(0.86, 0.83, 0.75)
const DIM := Color(0.56, 0.55, 0.52)
const PANEL := Color(0.03, 0.035, 0.05, 0.9)
const BORDER := Color(0.62, 0.42, 0.22, 0.85)

var _hover := -1 ## 0-3 worn slots, from 4 on the bag

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	size = Vector2(152, 136)
	mouse_filter = MOUSE_FILTER_STOP
	visible = false


func _process(_delta: float) -> void:
	if visible:
		queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT:
		_hover = -1


func cell_rect(i: int) -> Rect2:
	if i < 4:
		return Rect2(8 + i * 36, 20, CELL, CELL)
	var b := i - 4
	return Rect2(8 + (b % COLS) * 23, 60 + (b / COLS) * 23, CELL, CELL)


func _cell_at(pos: Vector2) -> int:
	for i in 4 + Player.BAG_SIZE:
		if cell_rect(i).has_point(pos):
			return i
	return -1


func _item(i: int) -> Dictionary:
	if i < 0:
		return {}
	if i < 4:
		return player.equipped[Loot.SLOTS[i]]
	return player.bag[i - 4] if i - 4 < player.bag.size() else {}


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_hover = _cell_at(event.position)
	var click := event as InputEventMouseButton
	if click and click.pressed:
		var i := _cell_at(click.position)
		if i >= 0 and i < 4:
			player.unequip(Loot.SLOTS[i])
		elif i >= 4 and not _item(i).is_empty():
			if click.button_index == MOUSE_BUTTON_RIGHT:
				player.salvage(i - 4)
			else:
				player.equip(i - 4)
		accept_event()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), PANEL)
	draw_rect(Rect2(Vector2(0.5, 0.5), size - Vector2.ONE), BORDER, false, 1.0)
	_text(Vector2(8, 12), "INVENTORY", Fx.GOLD)
	_text(Vector2(122, 12), "[I]", DIM)
	for i in 4 + Player.BAG_SIZE:
		var rect := cell_rect(i)
		var item := _item(i)
		draw_rect(rect, Color(0, 0, 0, 0.55))
		var edge: Color = Loot.COLORS[item.rarity] if not item.is_empty() else Color(0.3, 0.24, 0.16)
		draw_rect(Rect2(rect.position + Vector2(0.5, 0.5), rect.size - Vector2.ONE), edge if i != _hover else edge.lightened(0.4), false, 1.0)
		if not item.is_empty():
			draw_texture_rect_region(ICONS, Rect2(rect.position + Vector2(4, 4), Vector2(12, 12)), Rect2(Loot.SLOTS.find(item.slot) * 24, 0, 24, 24))
		elif i < 4:
			draw_texture_rect_region(ICONS, Rect2(rect.position + Vector2(4, 4), Vector2(12, 12)), Rect2(i * 24, 0, 24, 24), Color(1, 1, 1, 0.15))
		if i < 4:
			_text(rect.position + Vector2(-4, 30), Loot.SLOT_NAMES[Loot.SLOTS[i]].to_upper(), DIM)
	_text(Vector2(8, 118), "DMG %d   CRIT %d%%" % [roundi(player.damage()), roundi(player.crit_chance() * 100.0)], TEXT)
	_text(Vector2(8, 130), "ARMOR %d%%   HP %d" % [roundi(player.armor() * 100.0), roundi(player.max_health())], TEXT)
	var hovered := _item(_hover)
	if not hovered.is_empty():
		_tooltip(hovered, _hover < 4)


func _tooltip(item: Dictionary, worn: bool) -> void:
	var lines := Loot.describe(item)
	var box := Rect2(size.x + 4, cell_rect(_hover).position.y, 156, 38 + 11 * lines.size())
	draw_rect(box, Color(0.02, 0.02, 0.03, 0.95))
	draw_rect(Rect2(box.position + Vector2(0.5, 0.5), box.size - Vector2.ONE), Loot.COLORS[item.rarity], false, 1.0)
	_text(box.position + Vector2(5, 11), item.name, Loot.COLORS[item.rarity])
	_text(box.position + Vector2(5, 22), "%s %s" % [Loot.RARITY_NAMES[item.rarity], Loot.SLOT_NAMES[item.slot]], DIM)
	for j in lines.size():
		_text(box.position + Vector2(5, 34 + 11 * j), lines[j], TEXT)
	var hint := "click: take off" if worn else "click: wear  right: +%d XP" % Loot.VALUE[item.rarity]
	_text(box.position + Vector2(5, box.size.y - 4), hint, DIM)


func _text(pos: Vector2, words: String, color: Color) -> void:
	draw_string(FONT, pos, words, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, color)
