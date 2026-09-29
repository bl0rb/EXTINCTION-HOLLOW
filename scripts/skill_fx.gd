class_name SkillFx
extends Node2D
## Visible skills and builds (GAME_SPEC §150): swooshes, shockwaves, bite marks, spikes, sparkles and afterimages.
## Every effect draws itself in whole pixels, unlit so it shows at night too, fades and frees itself.

enum Kind { RING, SWOOSH, BITE, SPIKES, SPARKLE }

const DUST := preload("res://scenes/fx/dust.tscn")

static var _flat: CanvasItemMaterial
static var _glow: CanvasItemMaterial

var kind := Kind.RING
var radius := 20.0
var color := Color.WHITE
var life := 0.4
var turn := 1.0 ## the way a swoosh sweeps
var start := 0.0 ## where a swoosh starts, as an angle
var _t := 0.0


## An expanding shockwave on the ground (seen from above at an angle, so an ellipse).
static func ring(parent: Node, pos: Vector2, size: float, tint: Color, seconds := 0.45) -> SkillFx:
	return _spawn(parent, pos, Kind.RING, size, tint, seconds)


## A swoosh once around the dino, starting behind it.
static func swoosh(parent: Node, pos: Vector2, size: float, tint: Color, facing: float) -> SkillFx:
	var fx := _spawn(parent, pos, Kind.SWOOSH, size, tint, 0.3)
	fx.turn = -facing
	fx.start = PI if facing > 0.0 else 0.0
	return fx


## Two rows of teeth snapping shut.
static func bite(parent: Node, pos: Vector2, tint: Color, size := 1.0) -> SkillFx:
	return _spawn(parent, pos, Kind.BITE, size, tint, 0.3)


## Spikes shooting out all around.
static func spikes(parent: Node, pos: Vector2, tint: Color) -> SkillFx:
	return _spawn(parent, pos, Kind.SPIKES, 1.0, tint, 0.3)


## A small twinkling star.
static func sparkle(parent: Node, pos: Vector2, tint: Color, size := 1.0) -> SkillFx:
	return _spawn(parent, pos, Kind.SPARKLE, size, tint, 0.35)


## Puffs of dust in a circle on the ground.
static func dust_ring(parent: Node, pos: Vector2, size: float, count := 6) -> void:
	for i in count:
		Fx.burst(DUST, parent, pos + Vector2.from_angle(TAU * i / count) * Vector2(size, size * 0.5))


## A fading copy of a sprite that stays behind, e.g. while charging.
static func afterimage(sprite: Sprite2D, tint: Color) -> void:
	var ghost := Sprite2D.new()
	ghost.texture = sprite.texture
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.modulate = tint
	ghost.material = _material(true)
	sprite.get_parent().get_parent().add_child(ghost)
	ghost.global_transform = sprite.global_transform
	var tween := ghost.create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 0.25)
	tween.tween_callback(ghost.queue_free)


static func _spawn(parent: Node, pos: Vector2, what: Kind, size: float, tint: Color, seconds: float) -> SkillFx:
	var fx := SkillFx.new()
	fx.kind = what
	fx.radius = size
	fx.color = tint
	fx.life = seconds
	fx.material = _material()
	fx.position = pos.round()
	fx.z_index = 0 if what == Kind.RING else 1 # shockwaves lie on the ground, the rest in front of the animals
	parent.add_child(fx)
	return fx


static func _material(glowing := false) -> CanvasItemMaterial:
	if _flat == null:
		_flat = CanvasItemMaterial.new()
		_flat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		_glow = CanvasItemMaterial.new()
		_glow.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		_glow.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	return _glow if glowing else _flat


func _process(delta: float) -> void:
	_t += delta
	if _t >= life:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var p := _t / life
	match kind:
		Kind.RING:
			var r := radius * (0.25 + 0.75 * (1.0 - pow(1.0 - p, 3.0)))
			var fade := pow(1.0 - p, 1.5)
			_ellipse(r, color * Color(1, 1, 1, fade))
			_ellipse(r - 1.5, color * Color(1, 1, 1, fade * 0.45))
		Kind.SWOOSH:
			# the head races once around, the tail of the sweep fades behind it
			var head := minf(p * 1.5, 1.0) * TAU
			var steps := int(radius * 2.5)
			for i in steps:
				var along := float(i) / steps
				var a := start + turn * (head - along * PI * 1.1)
				if head - along * PI * 1.1 < 0.0:
					continue
				var fade := (1.0 - along) * (1.0 - p * 0.7)
				var at := Vector2(cos(a), sin(a) * 0.5)
				var band := 3.0 * (1.0 - along) + 1.0
				for k in int(band):
					_dot(at * (radius - k * 1.2), 1.0, color * Color(1, 1, 1, fade * (1.0 - k / (band + 1.0))))
				if along < 0.25:
					_dot(at * (radius + 1.0), 1.0, Color(1, 1, 1, fade))
		Kind.BITE:
			var gap := lerpf(6.0, 0.0, minf(p * 2.2, 1.0)) * radius
			var fade := 1.0 if p < 0.6 else (1.0 - p) / 0.4
			for i in 4:
				var x := (i - 1.5) * 2.5 * radius
				var arch := absf(i - 1.5) * 0.7 * radius
				var c := color * Color(1, 1, 1, fade)
				_dot(Vector2(x, -gap - 2.0 + arch), 1.0, c)
				_dot(Vector2(x, -gap - 1.0 + arch), 1.0, c)
				_dot(Vector2(x, gap + 1.0 - arch), 1.0, c)
				_dot(Vector2(x, gap + arch), 1.0, c)
			if p > 0.4 and p < 0.7:
				for arm in [Vector2(1, 0), Vector2(0, 1)]:
					for k in range(-2, 3):
						_dot(arm * k * radius, 1.0, Color(1, 1, 1, 0.9))
		Kind.SPIKES:
			var reach := 4.0 + 8.0 * (1.0 - pow(1.0 - p, 2.0))
			for i in 10:
				var dir := Vector2.from_angle(TAU * i / 10.0) * Vector2(1.0, 0.7)
				for k in 3:
					_dot(dir * (reach - k * 1.5), 1.0, color * Color(1, 1, 1, (1.0 - p) * (1.0 - k * 0.3)))
		Kind.SPARKLE:
			var arm := radius * 2.5 * (1.0 - absf(2.0 * p - 1.0))
			_dot(Vector2.ZERO, 0.5, Color(1, 1, 1, 1.0 - p * 0.5))
			for d in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
				for k in range(1, int(arm * 2.0) + 1):
					_dot(d * k * 0.5, 0.5, color * Color(1, 1, 1, 1.0 - k / (arm * 2.0 + 1.0)))


func _ellipse(r: float, c: Color) -> void:
	var count := maxi(12, int(TAU * r / 1.2))
	for i in count:
		var a := TAU * i / count
		_dot(Vector2(cos(a) * r, sin(a) * r * 0.5), 1.0, c)


## One square pixel of the effect, on its grid.
func _dot(at: Vector2, size: float, c: Color) -> void:
	draw_rect(Rect2((at / size).floor() * size, Vector2(size, size)), c)
