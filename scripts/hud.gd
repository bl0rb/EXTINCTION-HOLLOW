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

const SKILL_ICONS := preload("res://assets/talents.png")

var menu: PanelContainer
var warning: Label
var inventory: Control
var skill_tree: Control
var automap: Control
var narration: Label
var chapter: Label
var flash: ColorRect
var fade: ColorRect ## black, for going into and out of dungeons
var end_screen: Control
var _narration_tween: Tween
var _title: Label
var _rows := {} ## "player:health" -> [level label, buy button]

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var weather: Weather = get_tree().get_first_node_in_group("weather")


func _ready() -> void:
	add_to_group("hud")
	mouse_filter = MOUSE_FILTER_IGNORE
	theme = _make_theme()
	automap = Control.new()
	automap.set_script(load("res://scripts/automap.gd"))
	add_child(automap)
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
	inventory = Control.new()
	inventory.set_script(load("res://scripts/inventory_panel.gd"))
	inventory.position = Vector2(6, 96)
	add_child(inventory)
	skill_tree = Control.new()
	skill_tree.set_script(load("res://scripts/talent_panel.gd"))
	skill_tree.position = Vector2(640 - 158, 96)
	add_child(skill_tree)
	chapter = _story_label(16, Fx.GOLD, 116)
	narration = _story_label(8, TEXT, 136)
	narration.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	narration.size = Vector2(360, 40)
	narration.position.x = 140
	flash = ColorRect.new()
	flash.set_anchors_preset(PRESET_FULL_RECT)
	flash.mouse_filter = MOUSE_FILTER_IGNORE
	flash.color = Color(1, 0.95, 0.85, 0)
	add_child(flash)
	fade = ColorRect.new()
	fade.set_anchors_preset(PRESET_FULL_RECT)
	fade.mouse_filter = MOUSE_FILTER_IGNORE
	fade.color = Color(0, 0, 0, 0)
	add_child(fade)
	move_child(chapter, -1) # dungeon names show over the fade
	move_child(narration, -1)
	_build_end_screen()
	var story := get_tree().get_first_node_in_group("story") as Story
	if story:
		story.chapter_started.connect(func(i: int) -> void: narrate(Story.CHAPTERS[i].title, Story.CHAPTERS[i].text))
		story.impact_started.connect(_on_impact)
		story.ended.connect(_on_ended)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory.visible = not inventory.visible
	elif event.is_action_pressed("talents"):
		skill_tree.visible = not skill_tree.visible
	elif event.is_action_pressed("map"):
		automap.toggle()
	elif event.is_action_pressed("fullscreen"):
		var window := get_window()
		window.mode = Window.MODE_WINDOWED if window.mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN


func _story_label(font_size: int, color: Color, y: float) -> Label:
	var label := Label.new()
	label.label_settings = LabelSettings.new()
	label.label_settings.font = FONT
	label.label_settings.font_size = font_size
	label.label_settings.font_color = color
	label.label_settings.outline_size = 4
	label.label_settings.outline_color = Color(0.01, 0.01, 0.02, 0.85)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size = Vector2(640, font_size + 6)
	label.position = Vector2(0, y)
	label.mouse_filter = MOUSE_FILTER_IGNORE
	label.modulate.a = 0.0
	add_child(label)
	return label


## Storytelling (GAME_SPEC §149.29): a chapter title and a few words that write themselves out, linger and fade.
func narrate(title: String, text: String) -> void:
	chapter.text = title
	narration.text = text
	narration.visible_ratio = 0.0
	if _narration_tween:
		_narration_tween.kill()
	_narration_tween = create_tween()
	_narration_tween.tween_property(chapter, "modulate:a", 1.0 if title != "" else 0.0, 0.8)
	_narration_tween.parallel().tween_property(narration, "modulate:a", 1.0, 0.8)
	_narration_tween.tween_property(narration, "visible_ratio", 1.0, 0.05 * text.length())
	_narration_tween.tween_interval(4.0)
	_narration_tween.tween_property(chapter, "modulate:a", 0.0, 1.5)
	_narration_tween.parallel().tween_property(narration, "modulate:a", 0.0, 1.5)


## The impact (GAME_SPEC §126): a blinding flash, a moment of silence, then dust and darkness.
func _on_impact() -> void:
	var tween := create_tween()
	tween.tween_property(flash, "color", Color(1, 0.95, 0.85, 1.0), 0.15)
	tween.tween_interval(1.2)
	tween.tween_property(flash, "color", Color(0.06, 0.04, 0.03, 0.9), 2.4)


func _on_ended(survived: bool) -> void:
	var title: Label = end_screen.get_node("Title")
	title.text = "SURVIVED" if survived else "EXTINCT"
	title.label_settings.font_color = Fx.GOLD if survived else Fx.HURT
	end_screen.get_node("Text").text = "The dust settles after a long, cold age.\nThe hollow endured, and so did you." if survived \
		else "The hollow was not deep enough.\nThe cave collapses, and the age ends."
	end_screen.show()


func _build_end_screen() -> void:
	end_screen = Control.new()
	end_screen.set_anchors_preset(PRESET_FULL_RECT)
	end_screen.mouse_filter = MOUSE_FILTER_STOP
	end_screen.visible = false
	add_child(end_screen)
	var dark := ColorRect.new()
	dark.set_anchors_preset(PRESET_FULL_RECT)
	dark.color = Color(0.02, 0.015, 0.015, 0.94)
	dark.mouse_filter = MOUSE_FILTER_IGNORE
	end_screen.add_child(dark)
	for spec in [["Title", 32, 120], ["Text", 8, 170], ["Hint", 8, 230]]:
		var label := _story_label(spec[1], TEXT, spec[2])
		label.name = spec[0]
		label.modulate.a = 1.0
		label.size.y = 40
		remove_child(label)
		end_screen.add_child(label)
	end_screen.get_node("Hint").text = "click to begin a new age"
	end_screen.get_node("Hint").label_settings.font_color = DIM
	end_screen.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed:
			(get_tree().get_first_node_in_group("story") as Story).new_age())


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
	draw_rect(Rect2(6, 6, 118, 84), PANEL)
	draw_rect(Rect2(6.5, 6.5, 117, 83), BORDER, false, 1.0)
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
	var dungeons := get_tree().get_first_node_in_group("dungeons") as Dungeons
	var place := Biomes.name_at(player.global_position)
	if dungeons and dungeons.inside():
		place = Dungeon.THEMES[dungeons.current.theme].name
		_draw_boss_bar(dungeons.current.boss)
	_text(Vector2(11, 85), place, TEXT)
	_draw_skill_bar()
	var story := get_tree().get_first_node_in_group("story") as Story
	if story and story.warning() and int(Time.get_ticks_msec() / 400) % 3 != 0:
		var left := ceili(story.time_left())
		draw_string(FONT, Vector2(0, 22), "IMPACT  %d:%02d" % [left / 60, left % 60], HORIZONTAL_ALIGNMENT_CENTER, 640, 16, Fx.HURT)


## A dungeon boss in the fight gets a big health bar at the top of the screen.
func _draw_boss_bar(boss) -> void: # untyped: the boss may have been freed
	if not is_instance_valid(boss) or (boss.bar_time <= 0.0 and boss.global_position.distance_to(player.global_position) > 160.0):
		return
	draw_string(FONT, Vector2(0, 30), boss.title, HORIZONTAL_ALIGNMENT_CENTER, 640, 8, Fx.HURT)
	draw_rect(Rect2(220, 34, 200, 5), Color(0, 0, 0, 0.7))
	draw_rect(Rect2(221, 35, roundf(198 * boss.health / boss.max_health), 3), Color(0.8, 0.16, 0.12))


## Skills on the keys 1-4 with their cooldowns, the level and the XP towards the next one (GAME_SPEC §150).
func _draw_skill_bar() -> void:
	var ids: Array = Talents.DEFS.keys()
	var x0 := 277.0
	for i in Talents.SKILLS.size():
		var id: String = Talents.SKILLS[i]
		var def: Dictionary = Talents.DEFS[id]
		var rect := Rect2(x0 + i * 22, 330, 20, 20)
		var learned: bool = player.talents[id] > 0
		var affordable: bool = player.stamina >= def.stamina * (1.0 - 0.08 * player.talents.vigor)
		draw_rect(rect, PANEL)
		draw_texture_rect_region(SKILL_ICONS, Rect2(rect.position + Vector2(2, 2), Vector2(16, 16)), Rect2(ids.find(id) * 32, 0, 32, 32),
			Color.WHITE if learned and affordable else Color(0.35, 0.35, 0.35))
		var cooling: float = player.cooldowns[id] / def.cooldown
		if cooling > 0.0:
			draw_rect(Rect2(rect.position, Vector2(20, roundf(20 * cooling))), Color(0, 0, 0, 0.65))
		draw_rect(Rect2(rect.position + Vector2(0.5, 0.5), rect.size - Vector2.ONE), BORDER if learned else Color(0.3, 0.3, 0.3, 0.5), false, 1.0)
		_text(rect.position + Vector2(1, 7), str(i + 1), TEXT if learned else DIM)
	var level := player.level()
	_text(Vector2(x0 - 34, 344), "LV %d" % level, AMBER)
	var from := Talents.xp_for(level)
	var ratio := 1.0 if level >= Talents.MAX_LEVEL else float(player.total_xp - from) / (Talents.xp_for(level + 1) - from)
	draw_rect(Rect2(x0, 353, 86, 2), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(x0, 353, roundf(86 * ratio), 2), AMBER)
	if player.talent_points() > 0 and int(Time.get_ticks_msec() / 500) % 2 == 0:
		_text(Vector2(x0 + 92, 344), "+%d  K" % player.talent_points(), AMBER)


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
	menu.position = Vector2(640 - 196, 76)
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
	_title.text = "THE CAVE  -  %d XP   SHELTER %d/%d" % [player.banked_xp, cave.shelter(), Story.SHELTER_NEEDED]
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
