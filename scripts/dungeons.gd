class_name Dungeons
extends Node
## Enters and leaves random dungeons (GAME_SPEC §150): a fade, a freshly generated cave system below the world,
## a camera that stays inside it and a light the dino carries - and back to the entrance on the way out,
## or to the home cave after dying down there.

const ORIGIN := Vector2(0, 2600)

var current: Dungeon
var entrance: Node2D
var _busy := false
var _limits := []
var _light: PointLight2D

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	player.respawned.connect(_on_respawned)


func inside() -> bool:
	return current != null


func enter(from: Node2D) -> void:
	if _busy or current:
		return
	_busy = true
	entrance = from
	player.moving = false
	player.prey = null
	await _fade(1.0)
	current = Dungeon.new()
	current.name = "Dungeon"
	current.theme = from.theme
	current.tier = from.tier
	current.position = ORIGIN
	current.z_index = -1
	get_parent().add_child(current)
	current.build(randi())
	player.global_position = current.start_position()
	var camera := player.camera
	_limits = [camera.limit_left, camera.limit_top, camera.limit_right, camera.limit_bottom]
	var area := current.rect()
	camera.limit_left = int(area.position.x)
	camera.limit_top = int(area.position.y)
	camera.limit_right = int(area.end.x)
	camera.limit_bottom = int(area.end.y)
	camera.reset_smoothing()
	_light = PointLight2D.new()
	_light.texture = load("res://world/light_radial.tres")
	_light.color = Color(1.0, 0.85, 0.65)
	_light.energy = 0.9
	_light.texture_scale = 2.8
	_light.position = Vector2(0, -10)
	player.add_child(_light)
	var look: Dictionary = Dungeon.THEMES[from.theme]
	var hud := get_tree().get_first_node_in_group("hud")
	if hud:
		hud.narrate(look.name, look.text)
	await _fade(0.0)
	_busy = false


func leave() -> void:
	if _busy or current == null:
		return
	_busy = true
	player.moving = false
	player.prey = null
	await _fade(1.0)
	player.global_position = entrance.global_position + Vector2(0, 30)
	_close()
	player.camera.reset_smoothing()
	await _fade(0.0)
	_busy = false


func _close() -> void:
	current.queue_free()
	current = null
	var camera := player.camera
	camera.limit_left = _limits[0]
	camera.limit_top = _limits[1]
	camera.limit_right = _limits[2]
	camera.limit_bottom = _limits[3]
	if is_instance_valid(_light):
		_light.queue_free()


func _on_respawned() -> void:
	if current:
		_close()
		player.camera.reset_smoothing()


func _fade(alpha: float) -> void:
	var hud := get_tree().get_first_node_in_group("hud")
	if hud == null:
		return
	var tween := create_tween()
	tween.tween_property(hud.fade, "color:a", alpha, 0.35)
	await tween.finished
