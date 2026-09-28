extends Control
## Automap (GAME_SPEC §150): the map only shows what the dino has seen. A minimap in the corner, the whole map on M.
## Home, discovered lore sites and dungeon entrances are marked.

const CELL := 16 ## world pixels per map pixel
const REVEAL := 11 ## map pixels around the dino that it can see
const FONT := preload("res://assets/fonts/silkscreen-latin-400-normal.woff2")
const MINI := Vector2(100, 64)
const DIM := Color(0.56, 0.55, 0.52)
const BORDER := Color(0.62, 0.45, 0.25, 0.7)
const HIDDEN := Color(0.02, 0.025, 0.035)

var explored: Image ## one byte per map pixel, 255 once seen
var big := false
var _source: Image ## what the map looks like everywhere
var _view: Image ## the source where explored, dark elsewhere
var _texture: ImageTexture
var _reveal := 0.0
var _time := 0.0

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	set_anchors_preset(PRESET_FULL_RECT)
	_source = _world_image()
	var size_px := _source.get_size()
	explored = Image.create_empty(size_px.x, size_px.y, false, Image.FORMAT_L8)
	var saved: PackedByteArray = SaveGame.read("map", "explored", PackedByteArray())
	if saved.size() == size_px.x * size_px.y:
		explored.set_data(size_px.x, size_px.y, false, Image.FORMAT_L8, saved)
	_view = Image.create_empty(size_px.x, size_px.y, false, Image.FORMAT_RGBA8)
	_view.fill(HIDDEN)
	for y in size_px.y:
		for x in size_px.x:
			if explored.get_pixel(x, y).r > 0.5:
				_view.set_pixel(x, y, _source.get_pixel(x, y))
	_texture = ImageTexture.create_from_image(_view)


## The map picture: the ground seen from far above, with the water drawn in.
func _world_image() -> Image:
	var world := get_tree().get_first_node_in_group("world_map") as World
	if world:
		return world.map_image(CELL)
	var image := Image.create_empty(int(World.W) / CELL, int(World.H) / CELL, false, Image.FORMAT_RGBA8)
	image.fill(HIDDEN)
	return image


func explored_at(world_pos: Vector2) -> bool:
	var cell := (world_pos / CELL).floor()
	return Rect2(Vector2.ZERO, Vector2(explored.get_size())).has_point(cell) and explored.get_pixelv(Vector2i(cell)).r > 0.5


func _process(delta: float) -> void:
	_time += delta
	_reveal -= delta
	if _reveal <= 0.0 and Biomes.at(player.global_position) != Biomes.DUNGEON:
		_reveal = 0.2
		_reveal_around(player.global_position)
	queue_redraw()


func _reveal_around(world_pos: Vector2) -> void:
	var center := Vector2i((world_pos / CELL).floor())
	var changed := false
	for dy in range(-REVEAL, REVEAL + 1):
		for dx in range(-REVEAL, REVEAL + 1):
			var cell := center + Vector2i(dx, dy)
			if dx * dx + dy * dy > REVEAL * REVEAL or cell.x < 0 or cell.y < 0 or cell.x >= explored.get_width() or cell.y >= explored.get_height():
				continue
			if explored.get_pixelv(cell).r < 0.5:
				explored.set_pixelv(cell, Color.WHITE)
				_view.set_pixelv(cell, _source.get_pixelv(cell))
				changed = true
	if changed:
		_texture.update(_view)


func toggle() -> void:
	big = not big


func _draw() -> void:
	var dungeons := get_tree().get_first_node_in_group("dungeons") as Dungeons
	if dungeons and dungeons.inside():
		_draw_dungeon(dungeons.current)
		return
	if Biomes.at(player.global_position) == Biomes.DUNGEON:
		return
	var here := player.global_position / CELL
	if big:
		var scale := 2.0
		var size_px := Vector2(_view.get_size()) * scale
		var origin := ((Vector2(640, 360) - size_px) / 2.0).round()
		draw_rect(Rect2(origin - Vector2(6, 16), size_px + Vector2(12, 22)), Color(0.02, 0.02, 0.03, 0.92))
		draw_rect(Rect2(origin - Vector2(5.5, 15.5), size_px + Vector2(11, 21)), BORDER, false, 1.0)
		draw_string(FONT, origin + Vector2(0, -6), "MAP", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Fx.GOLD)
		draw_string(FONT, origin + Vector2(size_px.x - 18, -6), "[M]", HORIZONTAL_ALIGNMENT_LEFT, -1, 8, DIM)
		draw_texture_rect(_texture, Rect2(origin, size_px), false)
		_markers(origin, scale, Vector2.ZERO, Rect2(origin, size_px))
		return
	var rect := Rect2(Vector2(640 - 6 - MINI.x, 6), MINI)
	var from := (here - MINI / 2.0).round()
	draw_rect(rect, HIDDEN)
	var src := Rect2(from, MINI).intersection(Rect2(Vector2.ZERO, Vector2(_view.get_size())))
	if src.has_area():
		draw_texture_rect_region(_texture, Rect2(rect.position + src.position - from, src.size), src)
	_markers(rect.position, 1.0, from, rect)
	draw_rect(Rect2(rect.position - Vector2(0.5, 0.5), rect.size + Vector2.ONE), BORDER, false, 1.0)


## Down in a dungeon the map shows its tunnels as far as they have been explored, and the ways out.
func _draw_dungeon(dungeon: Dungeon) -> void:
	var scale := 4.0 if big else 1.0
	var size_px := Vector2(Dungeon.SIZE) * scale
	var frame := Rect2(((Vector2(640, 360) - size_px) / 2.0).round() - Vector2(6, 6), size_px + Vector2(12, 12)) if big else Rect2(Vector2(640 - 6 - MINI.x, 6), MINI)
	var origin := (frame.position + (frame.size - size_px) / 2.0).round()
	draw_rect(frame, Color(0.02, 0.02, 0.03, 0.92) if big else HIDDEN)
	draw_texture_rect(dungeon.map_texture, Rect2(origin, size_px), false)
	for door: Node2D in get_tree().get_nodes_in_group("dungeon_exit"):
		if dungeon.explored_at(door.global_position):
			_marker(origin + (door.global_position - dungeon.global_position) / Dungeon.CELL * scale, Color(0.7, 0.85, 1.0), 1.5 * sqrt(scale), frame)
	if int(_time * 3.0) % 2 == 0:
		_marker(origin + (player.global_position - dungeon.global_position) / Dungeon.CELL * scale, Color.WHITE, 1.5 * sqrt(scale), frame)
	draw_rect(Rect2(frame.position - Vector2(0.5, 0.5), frame.size + Vector2.ONE), BORDER, false, 1.0)


func _markers(origin: Vector2, scale: float, from: Vector2, clip: Rect2) -> void:
	var tree := get_tree()
	var cave := tree.get_first_node_in_group("cave") as Node2D
	if cave:
		_marker(origin + (cave.global_position / CELL - from) * scale, Fx.GOLD, 2.0, clip)
	for site: Node2D in tree.get_nodes_in_group("lore"):
		if site.story.found.has(site.id):
			_marker(origin + (site.global_position / CELL - from) * scale, Color(0.7, 0.82, 1.0), 1.0, clip)
	for entrance: Node2D in tree.get_nodes_in_group("dungeon_entrance"):
		if explored_at(entrance.global_position):
			_marker(origin + (entrance.global_position / CELL - from) * scale, Color(0.85, 0.3, 0.25), 1.5, clip)
	if int(_time * 3.0) % 2 == 0:
		_marker(origin + (player.global_position / CELL - from) * scale, Color.WHITE, 1.5, clip)


func _marker(pos: Vector2, color: Color, radius: float, clip: Rect2) -> void:
	pos = pos.round()
	if clip.grow(-1.0).has_point(pos):
		draw_rect(Rect2(pos - Vector2(radius, radius), Vector2(radius, radius) * 2.0), Color(0, 0, 0, 0.8))
		draw_rect(Rect2(pos - Vector2(radius - 0.5, radius - 0.5), Vector2(radius - 0.5, radius - 0.5) * 2.0), color)
