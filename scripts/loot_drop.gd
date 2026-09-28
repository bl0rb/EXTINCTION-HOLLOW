extends Node2D
## An item lying on the ground (GAME_SPEC §150): it bobs and glows in its rarity's colour until the dino walks over it.

var item := {}
var _time := randf() * TAU

@onready var icon: Sprite2D = $Icon
@onready var glow: PointLight2D = $Glow


func _ready() -> void:
	add_to_group("loot")
	icon.frame = Loot.SLOTS.find(item.slot)
	glow.color = Loot.COLORS[item.rarity]
	glow.energy = 0.35 + 0.25 * item.rarity


func _process(delta: float) -> void:
	_time += delta
	icon.position.y = -7.0 + roundf(sin(_time * 3.0) * 1.5)
