extends Control
## Start screen (GAME_SPEC §55, §153): five save slots to continue, delete or start anew.
## A new dino gets a name and a primary colour in a short wizard.

const HERO := preload("res://assets/player.png")
const SHADER := preload("res://shaders/hero.gdshader")
const GAME := "res://scenes/main.tscn"
const NAMES := ["Rex", "Ember", "Fang", "Talon", "Ash", "Moss", "Kiri", "Bolt", "Nyx", "Sabre", "Rook", "Dusk"]
const AMBER := Color(1.0, 0.72, 0.32)
const DIM := Color(0.56, 0.55, 0.52)
const TEXT := Color(0.86, 0.83, 0.75)

var slots: VBoxContainer
var wizard: PanelContainer
var name_field: LineEdit
var color_name: Label
var _new_slot := -1
var _color := 0
var _swatches: Array[Button] = []
var _preview: TextureRect
var _confirm := -1 ## the slot whose delete button asks "sure?"
var _time := 0.0


func _ready() -> void:
	theme = UiTheme.make()
	set_anchors_preset(PRESET_FULL_RECT)
	SaveGame.migrate()
	var back := ColorRect.new()
	back.color = Color(0.03, 0.04, 0.05)
	back.set_anchors_preset(PRESET_FULL_RECT)
	add_child(back)
	var title := _label("EXTINCTION HOLLOW", 24, AMBER)
	title.position = Vector2(0, 26)
	title.size = Vector2(640, 30)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var sub := _label("CHOOSE YOUR DINO", 8, DIM)
	sub.position = Vector2(0, 60)
	sub.size = Vector2(640, 12)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)
	slots = VBoxContainer.new()
	slots.position = Vector2(150, 82)
	slots.size = Vector2(340, 0)
	slots.add_theme_constant_override("separation", 4)
	add_child(slots)
	_build_wizard()
	var lan := _button("LAN MULTIPLAYER", func() -> void: get_tree().change_scene_to_file(Net.LOBBY))
	lan.position = Vector2(260, 328)
	lan.custom_minimum_size = Vector2(120, 18)
	add_child(lan)
	refresh()


func _process(delta: float) -> void:
	_time += delta
	if _preview and wizard.visible: # the dino breathes in the preview
		(_preview.texture as AtlasTexture).region.position.x = 96.0 * (int(_time / 0.7) % 2)


## Rebuilds the list of slots from the save files.
func refresh() -> void:
	for child in slots.get_children():
		child.queue_free()
	for i in SaveGame.SLOTS:
		slots.add_child(_slot_row(i))


func play(index: int, mode := "standard") -> void:
	SaveGame.slot = index
	SaveGame.mode = mode
	get_tree().change_scene_to_file(GAME)


func open_wizard(index: int) -> void:
	_new_slot = index
	name_field.text = NAMES.pick_random()
	_pick_color(0)
	slots.hide()
	wizard.show()
	name_field.grab_focus()
	name_field.select_all()


## Creates the dino in its slot and starts playing in a mode.
func start(mode := "standard") -> void:
	var dino_name := name_field.text.strip_edges()
	if dino_name == "":
		dino_name = NAMES.pick_random()
	SaveGame.create(_new_slot, dino_name, _color)
	play(_new_slot, mode)


func delete(index: int) -> void:
	if _confirm != index: # the first click asks, the second deletes
		_confirm = index
		refresh()
		return
	_confirm = -1
	SaveGame.delete(index)
	refresh()


func _slot_row(index: int) -> PanelContainer:
	var info := SaveGame.summary(index)
	var row := PanelContainer.new()
	row.custom_minimum_size = Vector2(340, 44)
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	row.add_child(box)
	var icon := _dino_icon(info.get("color", 0), Vector2(40, 30))
	icon.modulate.a = 1.0 if not info.is_empty() else 0.15
	box.add_child(icon)
	var text := VBoxContainer.new()
	text.add_theme_constant_override("separation", 0)
	text.size_flags_horizontal = SIZE_EXPAND_FILL
	box.add_child(text)
	if info.is_empty():
		text.add_child(_label("SLOT %d  -  EMPTY" % (index + 1), 8, DIM))
		text.add_child(_label("a new dino hatches here", 8, DIM))
	else:
		text.add_child(_label(str(info.name).to_upper(), 8, AMBER))
		text.add_child(_label("LV %d   CAVE %d   AGE %s" % [info.level, info.cave, ["I", "II", "III", "IV", "V"][info.phase]], 8, TEXT))
		text.add_child(_label(_date(info.played) + ("   BEST WAVE %d" % info.best if info.best > 0 else ""), 8, DIM))
	# a dino plays the standard game or survival with the same level, skills and items
	var actions := VBoxContainer.new()
	actions.add_theme_constant_override("separation", 2)
	actions.size_flags_vertical = SIZE_SHRINK_CENTER
	box.add_child(actions)
	if info.is_empty():
		actions.add_child(_button("NEW", open_wizard.bind(index)))
	else:
		actions.add_child(_button("STANDARD", play.bind(index, "standard")))
		actions.add_child(_button("SURVIVAL", play.bind(index, "survival")))
	if not info.is_empty():
		var remove := Button.new()
		remove.text = "SURE?" if _confirm == index else "X"
		remove.custom_minimum_size = Vector2(18 if _confirm != index else 40, 18)
		remove.size_flags_vertical = SIZE_SHRINK_CENTER
		remove.tooltip_text = "delete this save"
		remove.pressed.connect(delete.bind(index))
		box.add_child(remove)
	return row


func _build_wizard() -> void:
	wizard = PanelContainer.new()
	wizard.position = Vector2(150, 82)
	wizard.custom_minimum_size = Vector2(340, 0)
	wizard.hide()
	add_child(wizard)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	wizard.add_child(box)
	box.add_child(_label("A NEW DINO HATCHES", 8, AMBER))
	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 10)
	box.add_child(body)
	_preview = _dino_icon(0, Vector2(96, 72))
	body.add_child(_preview)
	var form := VBoxContainer.new()
	form.add_theme_constant_override("separation", 4)
	form.size_flags_horizontal = SIZE_EXPAND_FILL
	body.add_child(form)
	form.add_child(_label("1  NAME", 8, DIM))
	var name_row := HBoxContainer.new()
	form.add_child(name_row)
	name_field = LineEdit.new()
	name_field.max_length = 14
	name_field.size_flags_horizontal = SIZE_EXPAND_FILL
	name_field.text_submitted.connect(func(_text: String) -> void: start("standard"))
	name_row.add_child(name_field)
	var dice := Button.new()
	dice.text = "?"
	dice.tooltip_text = "a random name"
	dice.custom_minimum_size = Vector2(16, 0)
	dice.pressed.connect(func() -> void: name_field.text = NAMES.pick_random())
	name_row.add_child(dice)
	form.add_child(_label("2  PRIMARY COLOUR", 8, DIM))
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	form.add_child(grid)
	for i in Player.COLORS.size():
		var swatch := Button.new()
		swatch.custom_minimum_size = Vector2(22, 14)
		swatch.tooltip_text = Player.COLORS[i].name
		swatch.pressed.connect(_pick_color.bind(i))
		grid.add_child(swatch)
		_swatches.append(swatch)
	color_name = _label("", 8, TEXT)
	form.add_child(color_name)
	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 6)
	box.add_child(buttons)
	var back := Button.new()
	back.text = "BACK"
	back.pressed.connect(func() -> void:
		wizard.hide()
		slots.show())
	buttons.add_child(back)
	buttons.add_child(_label("3  PLAY", 8, DIM))
	buttons.add_child(_button("STANDARD", start.bind("standard")))
	buttons.add_child(_button("SURVIVAL", start.bind("survival")))


func _pick_color(index: int) -> void:
	_color = index
	Player.paint(_preview.material, index)
	color_name.text = Player.COLORS[index].name.to_upper()
	for i in _swatches.size():
		for look in ["normal", "hover", "pressed"]:
			var box := StyleBoxFlat.new()
			box.bg_color = Player.COLORS[i].color
			box.border_color = AMBER if i == index else Color(0.05, 0.05, 0.06)
			box.set_border_width_all(2 if i == index else 1)
			_swatches[i].add_theme_stylebox_override(look, box)


## The dino's first frame, painted in a primary colour.
func _dino_icon(color: int, box_size: Vector2) -> TextureRect:
	var atlas := AtlasTexture.new()
	atlas.atlas = HERO
	atlas.region = Rect2(0, 0, 96, 72)
	var icon := TextureRect.new()
	icon.texture = atlas
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = box_size
	var look := ShaderMaterial.new()
	look.shader = SHADER
	Player.paint(look, color)
	icon.material = look
	return icon


func _button(words: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = words
	button.custom_minimum_size = Vector2(64, 16)
	button.pressed.connect(action)
	return button


func _label(words: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = words
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _date(unix: float) -> String:
	if unix <= 0.0:
		return ""
	var local := int(unix) + int(Time.get_time_zone_from_system().get("bias", 0)) * 60
	return "played " + Time.get_datetime_string_from_unix_time(local, true).left(16)
