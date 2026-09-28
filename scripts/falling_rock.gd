extends Node2D
## A rock shaken loose by an earthquake: its shadow grows, it drops and hits the ground (GAME_SPEC §36, §149.19).

const FALL_TIME := 0.8
const HEIGHT := 180.0
const DUST := preload("res://scenes/fx/dust.tscn")
const RUBBLE := preload("res://scenes/rock_small.tscn")

@export var damage := 20.0
@export var hit_radius := 16.0

var _time := 0.0

@onready var rock: Sprite2D = $Rock
@onready var shadow: Sprite2D = $Shadow


func _process(delta: float) -> void:
	_time += delta
	var k := minf(_time / FALL_TIME, 1.0)
	rock.position.y = -8.0 - HEIGHT * (1.0 - k * k)
	shadow.scale = Vector2.ONE * (0.3 + 0.5 * k) * Art.SCALE
	if k >= 1.0:
		_land()


func _land() -> void:
	Fx.burst(DUST, get_parent(), global_position)
	Sound.play(get_parent(), "rock", global_position, -4.0)
	var player := get_tree().get_first_node_in_group("player") as Player
	var cave := get_tree().get_first_node_in_group("cave") as Cave
	var dist := player.global_position.distance_to(global_position)
	if dist < hit_radius and not cave.overlaps_body(player):
		player.take_damage(damage)
	elif dist > 30.0 and randf() < 0.25:
		# some rocks stay and block the way
		var rubble: Node2D = RUBBLE.instantiate()
		rubble.position = position
		get_parent().add_child(rubble)
	queue_free()
