class_name SkillTree
## Skill trees (GAME_SPEC §150): nodes joined by threads. A thread glows once its lower node is learned
## and shows bronze where the way is open; everything beyond stays dark.

const DARK := Color(0.24, 0.19, 0.13)
const OPEN := Color(0.62, 0.42, 0.22)
const LIT := Color(1.0, 0.72, 0.32)


## The colour of the thread from a parent to a child node.
static func thread_color(parent_rank: int, child_rank: int) -> Color:
	return LIT if child_rank > 0 else (OPEN if parent_rank > 0 else DARK)


## A thread from the bottom of one node to the top of another: down, across and down again, on whole pixels.
static func thread(canvas: CanvasItem, from: Rect2, to: Rect2, color: Color) -> void:
	var a := Vector2(floorf(from.get_center().x), from.end.y)
	var b := Vector2(floorf(to.get_center().x), to.position.y)
	var mid := floorf((a.y + b.y) / 2.0)
	var shadow := Color(0, 0, 0, 0.6)
	for pass_color in [shadow, color]:
		var o := Vector2.ONE if pass_color == shadow else Vector2.ZERO
		canvas.draw_rect(Rect2(Vector2(a.x, a.y) + o, Vector2(1, mid - a.y)), pass_color)
		canvas.draw_rect(Rect2(Vector2(minf(a.x, b.x), mid) + o, Vector2(absf(b.x - a.x) + 1, 1)), pass_color)
		canvas.draw_rect(Rect2(Vector2(b.x, mid) + o, Vector2(1, b.y - mid)), pass_color)
