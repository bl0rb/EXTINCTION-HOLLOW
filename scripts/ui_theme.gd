class_name UiTheme
## The look of panels, buttons and text fields (GAME_SPEC §149.31), shared by the HUD and the menus.

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")


static func make() -> Theme:
	var t := Theme.new()
	t.default_font = FONT
	t.default_font_size = 8
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
	for look in ["normal", "focus", "read_only"]:
		var field := StyleBoxFlat.new()
		field.bg_color = Color(0.02, 0.02, 0.03, 0.9)
		field.border_color = Color(1.0, 0.72, 0.32) if look == "focus" else Color(0.55, 0.38, 0.2)
		field.set_border_width_all(1)
		field.set_content_margin_all(3)
		t.set_stylebox(look, "LineEdit", field)
	t.set_color("font_color", "LineEdit", Color(1.0, 0.85, 0.55))
	t.set_color("caret_color", "LineEdit", Color(1.0, 0.72, 0.32))
	t.set_color("font_color", "Label", Color(0.86, 0.83, 0.75))
	t.set_color("font_color", "Button", Color(1.0, 0.72, 0.32))
	t.set_color("font_hover_color", "Button", Color(1.0, 0.85, 0.55))
	t.set_color("font_disabled_color", "Button", Color(0.56, 0.55, 0.52))
	# volume sliders in the options (GAME_SPEC §156): a thin track that fills amber up to a small grabber
	var track := StyleBoxFlat.new()
	track.bg_color = Color(0.02, 0.02, 0.03, 0.9)
	track.border_color = Color(0.55, 0.38, 0.2)
	track.set_border_width_all(1)
	track.content_margin_top = 2
	track.content_margin_bottom = 2
	t.set_stylebox("slider", "HSlider", track)
	var fills := {"grabber_area": Color(0.55, 0.38, 0.2), "grabber_area_highlight": Color(0.9, 0.62, 0.3)}
	for look: String in fills:
		var fill := StyleBoxFlat.new()
		fill.bg_color = fills[look]
		fill.content_margin_top = 2
		fill.content_margin_bottom = 2
		t.set_stylebox(look, "HSlider", fill)
	for look: String in ["grabber", "grabber_highlight"]:
		var knob := Image.create(4, 8, false, Image.FORMAT_RGBA8)
		knob.fill(Color(1.0, 0.72, 0.32) if look == "grabber" else Color(1.0, 0.85, 0.55))
		t.set_icon(look, "HSlider", ImageTexture.create_from_image(knob))
	return t

