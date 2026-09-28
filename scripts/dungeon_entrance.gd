extends Area2D
## The way into a random dungeon (GAME_SPEC §150) - or, down there, the way back up.

@export var theme := "den"
@export var tier := 1
@export var exit := false

@onready var glow: PointLight2D = $Glow


func _ready() -> void:
	add_to_group("dungeon_exit" if exit else "dungeon_entrance")
	body_entered.connect(_on_body_entered)
	if exit:
		glow.color = Color(0.7, 0.85, 1.0)
		glow.energy = 0.9


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	var dungeons := get_tree().get_first_node_in_group("dungeons") as Dungeons
	if exit:
		dungeons.leave()
	else:
		dungeons.enter(self)
