class_name Cave
extends Area2D
## The player's cave: walking into the entrance banks carried XP.

## Entrance size in pixels: clicks inside select the cave, the player inside enters it.
@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	body.enter_cave()
