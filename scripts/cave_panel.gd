extends Control
## The cave's upgrade tree (GAME_SPEC §16-§19, §150): banked XP grows the dino and the cave along two trees joined by threads.
## A click buys the next level of an upgrade whose thread leads to it.

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")
const ICONS := preload("res://assets/upgrades.png")
const LAYOUT := { ## column, row of each upgrade; the icons in upgrades.png follow this order
	"player:health": Vector2(0.5, 0), "player:speed": Vector2(0, 1), "player:bite": Vector2(1, 1), "player:size": Vector2(0.5, 2),
	"cave:level": Vector2(3.5, 0), "cave:strength": Vector2(2.5, 1), "cave:depth": Vector2(4.5, 1),
	"cave:quake": Vector2(2.5, 2), "cave:heat": Vector2(4, 2), "cave:cold": Vector2(5, 2),
}
const TEXT := Color(0.86, 0.83, 0.75)
const DIM := Color(0.56, 0.55, 0.52)
const PANEL := Color(0.03, 0.035, 0.05, 0.9)
const BORDER := Color(0.62, 0.42, 0.22, 0.85)

var _hover := ""

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")


func _ready() -> void:
	size = Vector2(196, 164)
	mouse_filter = MOUSE_FILTER_STOP
	visible = false


func _process(_delta: float) -> void:
	if visible:
		queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT:
		_hover = ""


func cell_rect(key: String) -> Rect2:
	var at: Vector2 = LAYOUT[key]
	return Rect2(10 + at.x * 30, 34 + at.y * 42, 20, 20)


## Buys the next level of an upgrade ("player:speed", "cave:depth") and saves.
func buy(key: String) -> bool:
	var id := key.get_slice(":", 1)
	var bought := player.buy_upgrade(id) if key.begins_with("player:") else cave.buy_upgrade(id, player)
	if bought:
		SaveGame.store(player, cave)
	return bought


func level_text(key: String) -> String:
	return "%d/%d" % [_level(key), _top(key)]


func _defs(key: String) -> Dictionary:
	return Upgrades.PLAYER if key.begins_with("player:") else Upgrades.CAVE


func _level(key: String) -> int:
	var id := key.get_slice(":", 1)
	return player.upgrades[id] if key.begins_with("player:") else cave.levels[id]


func _top(key: String) -> int:
	var id := key.get_slice(":", 1)
	return Upgrades.PLAYER[id].max if key.begins_with("player:") else cave.upgrade_max(id)


func _cost(key: String) -> int:
	var id := key.get_slice(":", 1)
	return player.upgrade_cost(id) if key.begins_with("player:") else cave.upgrade_cost(id)


func _can_buy(key: String) -> bool:
	var id := key.get_slice(":", 1)
	return player.can_upgrade(id) if key.begins_with("player:") else cave.can_upgrade(id, player.banked_xp)


func _key_at(pos: Vector2) -> String:
	for key: String in LAYOUT:
		if cell_rect(key).grow(2).has_point(pos):
			return key
	return ""


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_hover = _key_at(event.position)
	var click := event as InputEventMouseButton
	if click and click.pressed:
		var key := _key_at(click.position)
		if key != "":
			buy(key)
		accept_event()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), PANEL)
	draw_rect(Rect2(Vector2(0.5, 0.5), size - Vector2.ONE), BORDER, false, 1.0)
	_text(Vector2(8, 12), tr("THE CAVE"), Fx.GOLD)
	_text(Vector2(70, 12), "%d XP" % player.banked_xp, Fx.GOLD if player.banked_xp > 0 else DIM)
	var shelter := cave.shelter()
	_text(Vector2(120, 12), tr("SHELTER %d/%d") % [shelter, Story.SHELTER_NEEDED], TEXT if shelter >= Story.SHELTER_NEEDED else DIM)
	_text(Vector2(8, 26), "DINO", DIM)
	_text(Vector2(83, 26), tr("CAVE"), DIM)
	# threads first, from below each node's level to the top of the next
	for key: String in LAYOUT:
		var owner_id := key.get_slice(":", 0)
		for parent: String in _defs(key)[key.get_slice(":", 1)].get("needs", []):
			var from := cell_rect(owner_id + ":" + parent)
			from.size.y += 10
			SkillTree.thread(self, from, cell_rect(key), SkillTree.thread_color(_level(owner_id + ":" + parent), _level(key)))
	var index := 0
	for key: String in LAYOUT:
		var rect := cell_rect(key)
		var level := _level(key)
		var open := Upgrades.rooted(_defs(key), key.get_slice(":", 1), player.upgrades if key.begins_with("player:") else cave.levels)
		draw_rect(rect, Color(0, 0, 0, 0.55))
		var edge := Fx.GOLD if _can_buy(key) else (Color(0.55, 0.45, 0.3) if level > 0 else Color(0.3, 0.24, 0.16))
		draw_rect(Rect2(rect.position + Vector2(0.5, 0.5), rect.size - Vector2.ONE), edge.lightened(0.3) if key == _hover else edge, false, 1.0)
		var tint := Color.WHITE if level > 0 else (Color(0.6, 0.6, 0.6) if open else Color(0.25, 0.25, 0.25))
		draw_texture_rect_region(ICONS, Rect2(rect.position + Vector2(2, 2), Vector2(16, 16)), Rect2(index * 32, 0, 32, 32), tint)
		draw_string(FONT, rect.position + Vector2(-10, 29), level_text(key), HORIZONTAL_ALIGNMENT_CENTER, 40, 8, TEXT if level > 0 else DIM)
		index += 1
	if _hover != "":
		_tooltip(_hover)


func _tooltip(key: String) -> void:
	var id := key.get_slice(":", 1)
	var def: Dictionary = _defs(key)[id]
	var levels: Dictionary = player.upgrades if key.begins_with("player:") else cave.levels
	var lines := PackedStringArray([tr(def.info), tr("level %s") % level_text(key)])
	if _level(key) >= _top(key):
		lines.append(tr("cave level limits it") if key.begins_with("cave:") and id != "level" and _level(key) < Upgrades.CAVE.level.max else tr("fully grown"))
	else:
		lines.append("%d XP" % _cost(key))
		if not Upgrades.rooted(_defs(key), id, levels):
			lines.append(tr("needs %s") % (" %s " % tr("or")).join(PackedStringArray(def.needs.map(func(parent: String) -> String: return tr(_defs(key)[parent].name)))))
		elif _can_buy(key):
			lines.append(tr("click to build"))
		else:
			lines.append(tr("not enough XP"))
	var box := Rect2(-142, cell_rect(key).position.y, 138, 16 + 11 * lines.size())
	draw_rect(box, Color(0.02, 0.02, 0.03, 0.95))
	draw_rect(Rect2(box.position + Vector2(0.5, 0.5), box.size - Vector2.ONE), BORDER, false, 1.0)
	_text(box.position + Vector2(5, 11), tr(def.name), Fx.GOLD)
	for j in lines.size():
		_text(box.position + Vector2(5, 22 + 11 * j), lines[j], TEXT if j < 2 else DIM)


func _text(pos: Vector2, words: String, color: Color) -> void:
	draw_string(FONT, pos, words, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, color)
