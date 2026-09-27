extends Control
## HUD (GAME_SPEC §50, §137, §149.31): needs and XP in a small panel, the upgrade menu while the player is in the cave.

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")
const FONT_SIZE := 8
const TEXT := Color(0.86, 0.83, 0.75)
const DIM := Color(0.56, 0.55, 0.52)
const AMBER := Color(1.0, 0.72, 0.32)
const PANEL := Color(0.02, 0.03, 0.05, 0.6)
const BORDER := Color(0.62, 0.45, 0.25, 0.45)
const COLD := Color(0.55, 0.75, 1.0)
const HOT := Color(1.0, 0.55, 0.3)
const ICONS := {
	"health": [Color(0.86, 0.24, 0.2), [".XX.XX.", "XXXXXXX", "XXXXXXX", ".XXXXX.", "..XXX..", "...X..."]],
	"stamina": [Color(0.92, 0.84, 0.32), ["....XX.", "...XX..", "..XXXX.", "...XX..", "..XX...", ".XX...."]],
	"hunger": [Color(0.88, 0.52, 0.24), ["..XXX..", ".XXXXX.", ".XXXXX.", "..XXX..", "...X...", "..X.X.."]],
	"carried": [Color(1.0, 0.72, 0.32), ["..XXX..", ".XXXXX.", "XXX.XXX", "XXXXXXX", ".XXXXX.", "..XXX.."]],
	"banked": [Color(0.72, 0.68, 0.6), ["..XXX..", ".XXXXX.", "XX...XX", "XX...XX", "XX...XX", "XX...XX"]],
}

var menu: PanelContainer
var warning: Label
var _title: Label
var _rows := {} ## "player:health" -> [level label, buy button]

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var weather: Weather = get_tree().get_first_node_in_group("weather")


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	theme = _make_theme()
	_build_menu()
	cave.player_entered.connect(_open_menu)
	cave.player_exited.connect(menu.hide)
	warning = Label.new()
	warning.add_theme_font_size_override("font_size", 16)
	warning.add_theme_color_override("font_color", Color(0.9, 0.82, 0.7))
	warning.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	warning.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	warning.size = Vector2(640, 20)
	warning.position = Vector2(0, 70)
	warning.modulate.a = 0.0
	add_child(warning)
	var disasters := get_tree().get_first_node_in_group("disasters")
	if disasters:
		disasters.warning.connect(show_warning)


## Disaster warnings (GAME_SPEC §138): the text drifts in, lingers and fades away.
func show_warning(text: String) -> void:
	warning.text = text
	warning.position.y = 74
	var tween := create_tween()
	tween.tween_property(warning, "modulate:a", 1.0, 0.9)
	tween.parallel().tween_property(warning, "position:y", 70.0, 0.9)
	tween.tween_interval(2.5)
	tween.tween_property(warning, "modulate:a", 0.0, 1.5)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(6, 6, 118, 72), PANEL)
	draw_rect(Rect2(6.5, 6.5, 117, 71), BORDER, false, 1.0)
	_bar(11, "health", player.health / player.max_health(), Color(0.74, 0.18, 0.16), ceilf(player.health))
	_bar(21, "stamina", player.stamina / player.max_stamina, Color(0.8, 0.74, 0.26), ceilf(player.stamina))
	_bar(31, "hunger", player.hunger / player.max_hunger, Color(0.8, 0.46, 0.2), ceilf(player.hunger))
	_icon(Vector2(11, 42), "carried")
	_text(Vector2(21, 48), str(player.carried_xp), AMBER)
	_icon(Vector2(62, 42), "banked")
	_text(Vector2(72, 48), str(player.banked_xp), TEXT)
	_text(Vector2(11, 61), "SIZE %d" % player.get_size(), DIM)
	_text(Vector2(62, 61), "CAVE LV %d" % cave.levels.level, DIM)
	if weather:
		_text(Vector2(11, 73), weather.look.name, DIM)
		var temp_color := COLD if player.temperature < 5.0 else (HOT if player.temperature > 32.0 else DIM)
		_text(Vector2(84, 73), "%d°" % roundi(player.temperature), temp_color)


func _bar(y: float, icon: String, ratio: float, color: Color, value: float) -> void:
	_icon(Vector2(11, y), icon)
	draw_rect(Rect2(21, y + 1, 70, 5), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(21, y + 1, roundf(70 * clampf(ratio, 0.0, 1.0)), 5), color)
	draw_rect(Rect2(21, y + 1, roundf(70 * clampf(ratio, 0.0, 1.0)), 1), color.lightened(0.3))
	_text(Vector2(95, y + 6), "%d" % value, DIM)


func _icon(pos: Vector2, id: String) -> void:
	var rows: Array = ICONS[id][1]
	for y in rows.size():
		for x in rows[y].length():
			if rows[y][x] == "X":
				draw_rect(Rect2(pos + Vector2(x, y), Vector2.ONE), ICONS[id][0])


func _text(pos: Vector2, text: String, color: Color) -> void:
	draw_string(FONT, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, color)


func _build_menu() -> void:
	menu = PanelContainer.new()
	menu.visible = false
	add_child(menu)
	menu.position = Vector2(640 - 196, 60)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 1)
	menu.add_child(box)
	_title = Label.new()
	box.add_child(_title)
	for section in [["DINO", "player", Upgrades.PLAYER], ["CAVE", "cave", Upgrades.CAVE]]:
		var head := Label.new()
		head.text = section[0]
		head.add_theme_color_override("font_color", AMBER)
		box.add_child(head)
		for id: String in section[2]:
			var row := HBoxContainer.new()
			box.add_child(row)
			var label := Label.new()
			label.text = section[2][id].name
			label.tooltip_text = section[2][id].info
			label.mouse_filter = MOUSE_FILTER_PASS
			label.custom_minimum_size.x = 78
			row.add_child(label)
			var level := Label.new()
			level.custom_minimum_size.x = 28
			row.add_child(level)
			var button := Button.new()
			button.custom_minimum_size.x = 56
			button.focus_mode = FOCUS_NONE
			button.tooltip_text = section[2][id].info
			button.pressed.connect(_buy.bind(section[1], id))
			row.add_child(button)
			_rows["%s:%s" % [section[1], id]] = [level, button]


func _open_menu() -> void:
	_refresh()
	menu.show()


func _buy(owner_id: String, id: String) -> void:
	var bought := player.buy_upgrade(id) if owner_id == "player" else cave.buy_upgrade(id, player)
	if bought:
		SaveGame.store(player, cave)
	_refresh()


func _refresh() -> void:
	_title.text = "THE CAVE  -  %d XP" % player.banked_xp
	for key: String in _rows:
		var is_player := key.begins_with("player:")
		var id := key.get_slice(":", 1)
		var level: int = player.upgrades[id] if is_player else cave.levels[id]
		var top: int = Upgrades.PLAYER[id].max if is_player else cave.upgrade_max(id)
		_rows[key][0].text = "%d/%d" % [level, top]
		_rows[key][1].text = "MAX" if level >= top else "+  %d XP" % (player.upgrade_cost(id) if is_player else cave.upgrade_cost(id))
		_rows[key][1].disabled = not (player.can_upgrade(id) if is_player else cave.can_upgrade(id, player.banked_xp))


func _make_theme() -> Theme:
	var t := Theme.new()
	t.default_font = FONT
	t.default_font_size = FONT_SIZE
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color(0.03, 0.035, 0.05, 0.88)
	panel.border_color = Color(0.62, 0.42, 0.22, 0.85)
	panel.set_border_width_all(1)
	panel.set_content_margin_all(6)
	t.set_stylebox("panel", "PanelContainer", panel)
	var looks := {
		"normal": [Color(0.12, 0.09, 0.06), Color(0.55, 0.38, 0.2)],
		"hover": [Color(0.22, 0.15, 0.08), Color(0.9, 0.62, 0.3)],
		"pressed": [Color(0.32, 0.2, 0.08), Color(1.0, 0.72, 0.32)],
		"disabled": [Color(0.07, 0.07, 0.08), Color(0.25, 0.25, 0.27)],
	}
	for look: String in looks:
		var box := StyleBoxFlat.new()
		box.bg_color = looks[look][0]
		box.border_color = looks[look][1]
		box.set_border_width_all(1)
		box.content_margin_left = 4
		box.content_margin_right = 4
		box.content_margin_top = 0
		box.content_margin_bottom = 1
		t.set_stylebox(look, "Button", box)
	t.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	t.set_color("font_color", "Label", TEXT)
	t.set_color("font_color", "Button", AMBER)
	t.set_color("font_hover_color", "Button", Color(1.0, 0.85, 0.55))
	t.set_color("font_disabled_color", "Button", DIM)
	return t
