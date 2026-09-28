extends Node2D
## A place that tells a piece of the story (GAME_SPEC §149.29): old bones, scratched rock, a ring of stones.
## Walking up to it reveals its text once; afterwards it shows on the map.

const REACH := 30.0

@export var id := "bones"

var _check := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var glow: PointLight2D = $Glow
@onready var story: Story = get_tree().get_first_node_in_group("story")
@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	add_to_group("lore")
	sprite.frame = Story.LORE[id].kind
	glow.visible = not story.found.has(id)


func _process(delta: float) -> void:
	_check -= delta
	if _check > 0.0 or not glow.visible:
		return
	_check = 0.25
	if story.found.has(id): # found in an earlier session
		glow.visible = false
	elif player.global_position.distance_to(global_position) < REACH and story.discover(id):
		glow.visible = false
		var hud := get_tree().get_first_node_in_group("hud")
		if hud:
			hud.narrate("", Story.LORE[id].text)
		Fx.text(self, global_position + Vector2(0, -24), "+%d XP" % Story.LORE_XP, Fx.GOLD)
