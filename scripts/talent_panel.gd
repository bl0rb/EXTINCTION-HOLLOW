extends Control
## Skill tree (GAME_SPEC §150): three branches over three tiers of skills and traits, joined by threads;
## a click spends a talent point on a talent whose thread leads to it.

const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")
const ICONS := preload("res://assets/talents.png")
const LAYOUT := { ## column, row of each talent
	"sweep": Vector2(0, 0), "teeth": Vector2(1, 0), "hide": Vector2(2, 0),
	"charge": Vector2(0, 1), "instinct": Vector2(1, 1), "roar": Vector2(2, 1),
	"frenzy": Vector2(0.5, 2), "vigor": Vector2(2, 2),
}
const TEXT := Color(0.86, 0.83, 0.75)
const DIM := Color(0.56, 0.55, 0.52)
const PANEL := Color(0.03, 0.035, 0.05, 0.9)
const BORDER := Color(0.62, 0.42, 0.22, 0.85)

var _hover := ""

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
		_hover = ""


func cell_rect(id: String) -> Rect2:
	var at: Vector2 = LAYOUT[id]
	return Rect2(8 + at.x * 48, 22 + at.y * 34, 20, 20)


func _id_at(pos: Vector2) -> String:
	for id: String in Talents.DEFS:
		if cell_rect(id).has_point(pos):
			return id
	return ""


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_hover = _id_at(event.position)
	var click := event as InputEventMouseButton
	if click and click.pressed:
		var id := _id_at(click.position)
		if id != "":
			player.learn(id)
		accept_event()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), PANEL)
	draw_rect(Rect2(Vector2(0.5, 0.5), size - Vector2.ONE), BORDER, false, 1.0)
	_text(Vector2(8, 12), "SKILLS  LV %d" % player.level(), Fx.GOLD)
	_text(Vector2(122, 12), "[K]", DIM)
	var ids: Array = Talents.DEFS.keys()
	for id: String in Talents.DEFS:
		for parent: String in Talents.DEFS[id].get("needs", []):
			SkillTree.thread(self, cell_rect(parent), cell_rect(id), SkillTree.thread_color(player.talents[parent], player.talents[id]))
	for id: String in Talents.DEFS:
		var rect := cell_rect(id)
		var open: bool = player.level() >= Talents.TIER_LEVEL[Talents.DEFS[id].tier]
		var rank: int = player.talents[id]
		draw_rect(rect, Color(0, 0, 0, 0.55))
		var edge := Fx.GOLD if player.can_learn(id) else (Color(0.55, 0.45, 0.3) if rank > 0 else Color(0.3, 0.24, 0.16))
		draw_rect(Rect2(rect.position + Vector2(0.5, 0.5), rect.size - Vector2.ONE), edge.lightened(0.3) if id == _hover else edge, false, 1.0)
		var tint := Color.WHITE if rank > 0 else (Color(0.55, 0.55, 0.55) if open else Color(0.25, 0.25, 0.25))
		draw_texture_rect_region(ICONS, Rect2(rect.position + Vector2(2, 2), Vector2(16, 16)), Rect2(ids.find(id) * 32, 0, 32, 32), tint)
		_text(rect.position + Vector2(23, 14), "%d/%d" % [rank, Talents.MAX_RANK] if open else "LV%d" % Talents.TIER_LEVEL[Talents.DEFS[id].tier], TEXT if rank > 0 else DIM)
	var points := player.talent_points()
	_text(Vector2(8, 128), "POINTS %d" % points, Fx.GOLD if points > 0 else DIM)
	if _hover != "":
		_tooltip(_hover)


func _tooltip(id: String) -> void:
	var def: Dictionary = Talents.DEFS[id]
	var lines := PackedStringArray([def.info, "rank %d/%d" % [player.talents[id], Talents.MAX_RANK]])
	if def.has("cooldown"):
		lines.append("key %d  %d stamina  %ds" % [Talents.SKILLS.find(id) + 1, roundi(def.stamina), roundi(def.cooldown)])
	if not Talents.rooted(id, player.talents):
		lines.append("needs " + " or ".join(PackedStringArray(def.needs.map(func(parent: String) -> String: return Talents.DEFS[parent].name))))
	if player.level() < Talents.TIER_LEVEL[def.tier]:
		lines.append("needs level %d" % Talents.TIER_LEVEL[def.tier])
	elif player.can_learn(id):
		lines.append("click to learn")
	var box := Rect2(-140, cell_rect(id).position.y, 136, 16 + 11 * lines.size())
	draw_rect(box, Color(0.02, 0.02, 0.03, 0.95))
	draw_rect(Rect2(box.position + Vector2(0.5, 0.5), box.size - Vector2.ONE), BORDER, false, 1.0)
	_text(box.position + Vector2(5, 11), def.name, Fx.GOLD)
	for j in lines.size():
		_text(box.position + Vector2(5, 22 + 11 * j), lines[j], TEXT if j < 2 else DIM)


func _text(pos: Vector2, words: String, color: Color) -> void:
	draw_string(FONT, pos, words, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, color)
