extends Node2D
## A glowing rock thrown by the volcano: flies in an arc and sets the ground on fire where it lands.

const FIRE := preload("res://scenes/fire.tscn")
const DUST := preload("res://scenes/fx/dust.tscn")

@export var start := Vector2.ZERO ## ground point below the launch spot
@export var start_height := 0.0 ## height above that ground point
@export var target := Vector2.ZERO
@export var damage := 30.0
@export var flight_time := 1.6
@export var arc := 160.0
@export var hit_radius := 22.0

var _time := 0.0

@onready var bomb: Sprite2D = $Bomb
@onready var shadow: Sprite2D = $Shadow


func _ready() -> void:
	global_position = start


func _process(delta: float) -> void:
	_time += delta
	var k := minf(_time / flight_time, 1.0)
	global_position = start.lerp(target, k) # drawn in order by where it is above the ground
	bomb.position.y = -start_height * (1.0 - k) - arc * 4.0 * k * (1.0 - k)
	shadow.position = target - global_position
	shadow.scale = Vector2.ONE * (0.2 + 0.6 * k)
	if k >= 1.0:
		_land()


func _land() -> void:
	var fire: Node2D = FIRE.instantiate()
	fire.position = target
	get_parent().add_child(fire)
	Fx.burst(DUST, get_parent(), target)
	var player := get_tree().get_first_node_in_group("player") as Player
	var cave := get_tree().get_first_node_in_group("cave") as Cave
	if player.global_position.distance_to(target) < hit_radius and not cave.overlaps_body(player):
		player.take_damage(damage)
	queue_free()
