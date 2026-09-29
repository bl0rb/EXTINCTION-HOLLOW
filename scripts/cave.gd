class_name Cave
extends Area2D
## The player's cave: walking into the entrance banks carried XP and saves; banked XP buys cave upgrades here.

signal player_entered
signal player_exited

## Entrance size in pixels: clicks inside select the cave, the player inside enters it.
@onready var radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
@onready var sprite: Sprite2D = $Sprite2D
@onready var fire: Flicker = $FireLight

const MOUTH := [0, 24, 28, 32, 36, 40] ## half width of the cave mouth per cave level
const HEIGHT := [0, 31, 36, 41, 46, 51] ## height of the cave mouth per cave level

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


## How well the cave shelters against the meteor (GAME_SPEC §45): its level counts double, every stat once.
func shelter() -> int:
	return levels.level * 2 + levels.strength + levels.depth + levels.heat + levels.quake + levels.cold


func can_upgrade(id: String, xp: int) -> bool:
	return levels[id] < upgrade_max(id) and xp >= upgrade_cost(id) and Upgrades.rooted(Upgrades.CAVE, id, levels)


func buy_upgrade(id: String, player: Player) -> bool:
	if not can_upgrade(id, player.banked_xp):
		return false
	player.banked_xp -= upgrade_cost(id)
	levels[id] += 1
	_apply_level()
	return true


## Every upgrade shows (GAME_SPEC §15, §128, §149.21): the cave itself grows with its level
## (food store, side chamber, stone pillars, ember-lit fortress), each stat adds its own parts.
func _apply_level() -> void:
	var level: int = levels.level
	var half: float = MOUTH[level]
	sprite.frame = level - 1
	fire.intensity = 1.0 + 0.15 * (level - 1)
	_part($Steps, "depth", Vector2(0, -15)) # steps lead down into the deep shelter
	_part($Moss, "heat", Vector2(0, 7 - HEIGHT[level])) # damp moss keeps the heat out
	_part($PillarL, "quake", Vector2(-half - 5, -30)) # stone braces against earthquakes
	_part($PillarR, "quake", Vector2(half + 5, -30))
	_part($WallL, "strength", Vector2(-half - 36, -14)) # piled stone walls
	_part($WallR, "strength", Vector2(half + 36, -14))
	_part($Nest, "cold", Vector2(0, -6)) # a bed of leaves against the cold
	$Drips.emitting = levels.heat > 0
	$Drips.position = Vector2(0, 14 - HEIGHT[level])
	$DeepGlow.visible = levels.depth > 0
	$DeepGlow.intensity = 0.6 + 0.25 * levels.depth


func _part(part: Sprite2D, stat: String, pos: Vector2) -> void:
	part.visible = levels[stat] > 0
	part.frame = mini(levels[stat] / 2, 2) # bigger at stat level 2 and 4
	part.position = pos


func _on_body_entered(body: Node2D) -> void:
	body.enter_cave()
	SaveGame.store(body, self)
	player_entered.emit()
