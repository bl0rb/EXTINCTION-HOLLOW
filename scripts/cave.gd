class_name Cave
extends Area2D
## The player's cave: walking into the entrance banks carried XP and saves; banked XP buys cave upgrades here.

signal player_entered
signal player_exited

## Entrance size in pixels: clicks inside select the cave, the player inside enters it.
@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var fire: Flicker = $FireLight
@onready var _sprite_y := sprite.position.y

var levels := {"level": 1, "strength": 0, "depth": 0, "heat": 0, "quake": 0, "cold": 0}


func _ready() -> void:
	levels.merge(SaveGame.read("cave", "levels", {}), true)
	body_entered.connect(_on_body_entered)
	body_exited.connect(func(_body: Node2D) -> void: player_exited.emit())
	_apply_level()


func is_clicked(point: Vector2) -> bool:
	return point.distance_to(global_position) <= radius or sprite.get_rect().has_point(sprite.to_local(point))


func upgrade_cost(id: String) -> int:
	# the cave starts at level 1, its stats at 0
	return Upgrades.cost(Upgrades.CAVE[id], levels[id] - (1 if id == "level" else 0))


func upgrade_max(id: String) -> int:
	return Upgrades.CAVE.level.max if id == "level" else levels.level


func can_upgrade(id: String, xp: int) -> bool:
	return levels[id] < upgrade_max(id) and xp >= upgrade_cost(id)


func buy_upgrade(id: String, player: Player) -> bool:
	if not can_upgrade(id, player.banked_xp):
		return false
	player.banked_xp -= upgrade_cost(id)
	levels[id] += 1
	_apply_level()
	return true


## The cave visibly grows with its level (GAME_SPEC §149.21).
func _apply_level() -> void:
	var s: float = 1.0 + 0.06 * (levels.level - 1)
	sprite.scale = Vector2(s, s)
	sprite.position.y = (_sprite_y + 4.0) * s - 4.0 # keep the cave mouth on the ground
	fire.intensity = 1.0 + 0.15 * (levels.level - 1)


func _on_body_entered(body: Node2D) -> void:
	body.enter_cave()
	SaveGame.store(body, self)
	player_entered.emit()
