class_name Fx
## One-shot effects: particle bursts, a short hit stop that makes bites feel heavy, and floating combat text.

const BLOOD := preload("res://scenes/fx/blood.tscn")
const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")
const WHITE := Color(0.95, 0.93, 0.88)
const CRIT := Color(1.0, 0.82, 0.25)
const HURT := Color(1.0, 0.35, 0.3)
const GOLD := Color(1.0, 0.72, 0.32)


static func burst(scene: PackedScene, parent: Node, pos: Vector2) -> void:
	var particles: CPUParticles2D = scene.instantiate()
	particles.position = pos
	parent.add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)


static func hit_stop(tree: SceneTree, seconds := 0.06) -> void:
	Engine.time_scale = 0.05
	await tree.create_timer(seconds, true, false, true).timeout
	Engine.time_scale = 1.0


## Damage numbers (GAME_SPEC §150): critical hits are bigger and golden.
static func number(source: Node, pos: Vector2, amount: float, color := WHITE, crit := false) -> void:
	text(source, pos, ("%d!" if crit else "%d") % ceili(amount), CRIT if crit else color, 16 if crit else 8)


## Text that floats up and fades, drawn above the night darkness.
static func text(source: Node, pos: Vector2, words: String, color: Color, size := 8) -> void:
	var layer := source.get_tree().get_first_node_in_group("world_ui")
	if layer == null:
		return
	var label := Label.new()
	label.text = words
	label.label_settings = LabelSettings.new()
	label.label_settings.font = FONT
	label.label_settings.font_size = size
	label.label_settings.font_color = color
	label.label_settings.outline_size = 3
	label.label_settings.outline_color = Color(0.02, 0.02, 0.03, 0.9)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size = Vector2(120, size + 4)
	label.position = (pos - Vector2(60, size)).round()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(label)
	var tween := label.create_tween()
	tween.tween_property(label, "position:y", label.position.y - 14.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5).set_delay(0.4)
	tween.tween_callback(label.queue_free)
