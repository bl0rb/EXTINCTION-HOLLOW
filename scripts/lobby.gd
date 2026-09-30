extends Control
## LAN lobby (GAME_SPEC §155): bring one of your dinos, host a game or join one by its address.
## The host picks versus or survival and starts the round for everyone, up to eight dinos.

const AMBER := Color(1.0, 0.72, 0.32)
const DIM := Color(0.56, 0.55, 0.52)
const TEXT := Color(0.86, 0.83, 0.75)

var status_label: Label
var address_field: LineEdit
var port_field: LineEdit
var dino_choice: OptionButton
var _panel: VBoxContainer
var _slots: Array[int] = [] ## save slots in the order of the dino choice


func _ready() -> void:
	theme = UiTheme.make()
	set_anchors_preset(PRESET_FULL_RECT)
	var back := ColorRect.new()
	back.color = Color(0.03, 0.04, 0.05)
	back.set_anchors_preset(PRESET_FULL_RECT)
	add_child(back)
	var title := _label("LAN MULTIPLAYER", 16, AMBER)
	title.position = Vector2(0, 24)
	title.size = Vector2(640, 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var frame := PanelContainer.new()
	frame.position = Vector2(170, 60)
	frame.custom_minimum_size = Vector2(300, 0)
	add_child(frame)
	_panel = VBoxContainer.new()
	_panel.add_theme_constant_override("separation", 5)
	frame.add_child(_panel)
	status_label = _label("", 8, DIM)
	status_label.position = Vector2(0, 336)
	status_label.size = Vector2(640, 12)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(status_label)
	Net.hub().roster_changed.connect(refresh)
	Net.hub().status.connect(func(text: String) -> void:
		status_label.text = text
		refresh())
	refresh()


## Rebuilds the panel: the setup before a session, the roster during one.
func refresh() -> void:
	for child in _panel.get_children():
		child.queue_free()
	if Net.active and not Net.players.is_empty():
		_build_session()
	elif Net.active:
		_panel.add_child(_label("CONNECTING ...", 8, TEXT))
		_panel.add_child(_button("CANCEL", func() -> void: Net.leave()))
	else:
		_build_setup()


func host() -> void:
	_bring_dino()
	Net.host(int(port_field.text) if port_field.text.is_valid_int() else Net.PORT)


func join() -> void:
	_bring_dino()
	var address := address_field.text.strip_edges()
	Net.join(address if address != "" else "127.0.0.1", int(port_field.text) if port_field.text.is_valid_int() else Net.PORT)
	refresh()


func _bring_dino() -> void:
	SaveGame.slot = _slots[dino_choice.selected]
	SaveGame.mode = "standard"
	Net.load_profile()


func _build_setup() -> void:
	_slots.clear()
	for i in SaveGame.SLOTS:
		if SaveGame.exists(i):
			_slots.append(i)
	_panel.add_child(_label("YOUR DINO", 8, DIM))
	if _slots.is_empty():
		_panel.add_child(_label("hatch a dino on the start screen first", 8, TEXT))
		_panel.add_child(_button("BACK", func() -> void: get_tree().change_scene_to_file(Net.TITLE)))
		return
	dino_choice = OptionButton.new()
	for slot in _slots:
		var info := SaveGame.summary(slot)
		dino_choice.add_item("%s   LV %d" % [str(info.name).to_upper(), info.level])
	dino_choice.select(maxi(_slots.find(SaveGame.slot), 0))
	_panel.add_child(dino_choice)
	_panel.add_child(_label("PORT", 8, DIM))
	port_field = LineEdit.new()
	port_field.text = str(Net.PORT)
	_panel.add_child(port_field)
	_panel.add_child(_button("HOST A GAME", host))
	_panel.add_child(_label("OR JOIN A HOST IN YOUR NETWORK", 8, DIM))
	var row := HBoxContainer.new()
	_panel.add_child(row)
	address_field = LineEdit.new()
	address_field.placeholder_text = "192.168.0.10"
	address_field.size_flags_horizontal = SIZE_EXPAND_FILL
	address_field.text_submitted.connect(func(_text: String) -> void: join())
	row.add_child(address_field)
	row.add_child(_button("JOIN", join))
	_panel.add_child(_button("BACK", func() -> void: get_tree().change_scene_to_file(Net.TITLE)))


func _build_session() -> void:
	_panel.add_child(_label("PLAYERS  %d/%d" % [Net.players.size(), Net.MAX_PLAYERS], 8, DIM))
	var ids: Array = Net.players.keys()
	ids.sort()
	for id: int in ids:
		var info: Dictionary = Net.players[id]
		var row := HBoxContainer.new()
		var swatch := ColorRect.new()
		swatch.custom_minimum_size = Vector2(8, 8)
		swatch.size_flags_vertical = SIZE_SHRINK_CENTER
		swatch.color = Player.COLORS[clampi(info.get("color", 0), 0, Player.COLORS.size() - 1)].color
		row.add_child(swatch)
		row.add_child(_label("%s   LV %d%s%s" % [str(info.get("name", "?")).to_upper(), info.get("level", 1), "   HOST" if id == 1 else "",
			"   (YOU)" if id == Net.my_id() else ""], 8, AMBER if id == Net.my_id() else TEXT))
		_panel.add_child(row)
	_panel.add_child(_label("MODE", 8, DIM))
	if Net.is_host():
		var modes := HBoxContainer.new()
		modes.add_theme_constant_override("separation", 4)
		for mode in Net.MODES:
			var button := _button(mode.to_upper(), func() -> void: Net.set_mode(mode))
			button.toggle_mode = true
			button.button_pressed = Net.mode == mode # the chosen mode looks pressed
			modes.add_child(button)
		_panel.add_child(modes)
		var addresses := Net.local_addresses()
		_panel.add_child(_label("OTHERS JOIN AT  %s" % (", ".join(addresses) if not addresses.is_empty() else "your IP"), 8, TEXT))
		_panel.add_child(_button("START", func() -> void: Net.start_game()))
	else:
		_panel.add_child(_label(Net.mode.to_upper(), 8, TEXT))
		_panel.add_child(_label("the host starts the round", 8, DIM))
	_panel.add_child(_label("VERSUS: the dinos fight each other" if Net.mode == "versus" else "SURVIVAL: waves together, an ultraboss every fifth wave", 8, DIM))
	_panel.add_child(_button("LEAVE", func() -> void: Net.leave()))


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
