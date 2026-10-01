class_name OptionsPanel
extends PanelContainer
## The options (GAME_SPEC §156), opened from the start screen and the Esc menu. Every change counts at once and is kept.

signal closed

const AMBER := Color(1.0, 0.72, 0.32)
const DIM := Color(0.56, 0.55, 0.52)

var _language: Button


func _ready() -> void:
	Settings.ensure()
	custom_minimum_size = Vector2(240, 0)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	add_child(box)
	var title := Label.new()
	title.text = "OPTIONS"
	title.add_theme_color_override("font_color", AMBER)
	box.add_child(title)
	box.add_child(_slider("VOLUME", Settings.volume, func(value: float) -> void: Settings.volume = value))
	box.add_child(_slider("AMBIENCE", Settings.ambience, func(value: float) -> void: Settings.ambience = value))
	box.add_child(_slider("EFFECTS", Settings.effects, func(value: float) -> void: Settings.effects = value))
	box.add_child(_toggle("FULLSCREEN", Settings.fullscreen, func(on: bool) -> void: Settings.fullscreen = on))
	box.add_child(_toggle("SCREEN SHAKE", Settings.shake, func(on: bool) -> void: Settings.shake = on))
	_language = Button.new()
	_language.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED # every language keeps its own name
	_language.pressed.connect(_next_language)
	box.add_child(_row("LANGUAGE", _language))
	_language.text = Settings.LANGUAGES[Settings.locale()]
	var back := Button.new()
	back.text = "BACK"
	back.custom_minimum_size = Vector2(0, 16)
	back.pressed.connect(close)
	box.add_child(back)


func close() -> void:
	hide()
	closed.emit()


func _next_language() -> void:
	var codes: Array = Settings.LANGUAGES.keys()
	Settings.language = codes[(codes.find(Settings.locale()) + 1) % codes.size()]
	Settings.save()
	_language.text = Settings.LANGUAGES[Settings.locale()]


func _slider(words: String, value: float, change: Callable) -> HBoxContainer:
	var slider := HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.05
	slider.value = value
	slider.size_flags_vertical = SIZE_SHRINK_CENTER
	var amount := Label.new()
	amount.custom_minimum_size = Vector2(30, 0)
	amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	amount.add_theme_color_override("font_color", DIM)
	amount.text = "%d%%" % roundi(value * 100.0)
	slider.value_changed.connect(func(new_value: float) -> void:
		change.call(new_value)
		amount.text = "%d%%" % roundi(new_value * 100.0)
		Settings.save())
	var row := _row(words, slider)
	row.add_child(amount)
	return row


func _toggle(words: String, on: bool, change: Callable) -> HBoxContainer:
	var button := Button.new()
	button.toggle_mode = true
	button.button_pressed = on
	button.text = "ON" if on else "OFF"
	button.toggled.connect(func(now: bool) -> void:
		change.call(now)
		button.text = "ON" if now else "OFF"
		Settings.save())
	return _row(words, button)


func _row(words: String, control: Control) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	var label := Label.new()
	label.text = words
	label.custom_minimum_size = Vector2(96, 0)
	row.add_child(label)
	control.custom_minimum_size.y = 14
	control.size_flags_horizontal = SIZE_EXPAND_FILL
	row.add_child(control)
	return row
