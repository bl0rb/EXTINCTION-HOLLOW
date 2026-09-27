extends Node2D
## Fireflies drifting through the jungle; they scatter when the player comes close.

@export var area := Rect2(0, 0, 1280, 960)
@export var count := 80
@export var color := Color(0.85, 1.0, 0.45)
@export var flee_radius := 48.0

var _pos := PackedVector2Array()
var _vel := PackedVector2Array()
var _phase := PackedFloat32Array()
var _time := 0.0

@onready var _player: Node2D = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	for i in count:
		_pos.append(area.position + area.size * Vector2(randf(), randf()))
		_vel.append(Vector2.from_angle(randf() * TAU) * 6.0)
		_phase.append(randf() * TAU)


func _process(delta: float) -> void:
	_time += delta
	var near := _player.global_position + Vector2(0, -12)
	for i in count:
		var vel := _vel[i].rotated(randf_range(-2.0, 2.0) * delta)
		var away := _pos[i] - near
		if away.length() < flee_radius:
			vel += away.normalized() * 160.0 * delta
		# calm down to a slow drift again
		vel = vel.move_toward(vel.normalized() * 6.0, 25.0 * delta).limit_length(45.0)
		_vel[i] = vel
		var p := _pos[i] + vel * delta
		_pos[i] = Vector2(wrapf(p.x, area.position.x, area.end.x), wrapf(p.y, area.position.y, area.end.y))
	queue_redraw()


func _draw() -> void:
	for i in count:
		var glow := 0.5 + 0.5 * sin(_time * 2.3 + _phase[i])
		if glow < 0.15:
			continue
		var p := _pos[i].round()
		draw_rect(Rect2(p - Vector2.ONE, Vector2(3, 3)), Color(color, 0.18 * glow))
		draw_rect(Rect2(p, Vector2.ONE), Color(color, glow))
