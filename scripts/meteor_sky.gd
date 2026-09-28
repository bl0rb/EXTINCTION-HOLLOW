extends Node2D
## The meteor in the sky (GAME_SPEC §125, §149.29): a faint point at first, then a star, a glowing body with a tail
## and finally the brightest thing in the world. Drawn in screen space above the night.

var _time := 0.0

@onready var story: Story = get_tree().get_first_node_in_group("story")
@onready var player: Player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	if story == null or story.state == &"over" or Biomes.at(player.global_position) == Biomes.DUNGEON:
		return
	var p := story.progress()
	# far away it hardly moves; the camera shifts it a little for depth
	var pos := (Vector2(470, 52) - player.global_position * 0.008 + Vector2(-60, 40) * p * p).round()
	var size := 1.0 + 16.0 * p * p
	var twinkle := 0.75 + 0.25 * sin(_time * 5.0) if p < 0.3 else 1.0
	var tail := Vector2(1, -0.55).normalized()
	var length := 90.0 * pow(p, 1.5)
	for i in 12:
		var k := i / 12.0
		draw_circle(pos + tail * length * k, maxf(size * (1.0 - k) * 0.8, 0.5), Color(1.0, 0.55 - 0.3 * k, 0.2, 0.16 * (1.0 - k) * minf(p * 3.0, 1.0)))
	for ring in [[4.0, 0.08], [2.4, 0.16], [1.5, 0.32]]:
		draw_circle(pos, size * ring[0] + 1.0, Color(1.0, 0.6, 0.3, ring[1] * twinkle * minf(0.4 + p, 1.0)))
	draw_circle(pos, size, Color(1.0, 0.92, 0.75, twinkle))
