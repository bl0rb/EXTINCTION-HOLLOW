extends StaticBody2D
## Tree whose canopy fades while the player walks behind it (GAME_SPEC §149.9).

const CANOPY := Rect2(-44, -100, 88, 96) ## canopy area relative to the trunk base

@export var variant := 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	sprite.frame = variant


func _process(delta: float) -> void:
	var behind := CANOPY.has_point(player.global_position - global_position)
	sprite.modulate.a = move_toward(sprite.modulate.a, 0.4 if behind else 1.0, delta * 3.0)
