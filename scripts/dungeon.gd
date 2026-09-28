class_name Dungeon
extends Node2D
## A random cave system (GAME_SPEC §150): rooms joined by tunnels, different every time.
## Beasts in every room, now and then an elite, a boss in the room furthest from the way in,
## a hoard of trophies somewhere - and a map that fills in while the dino explores.

const CELL := 16
const SIZE := Vector2i(60, 44)
const REVEAL := 7 ## cells around the dino that show on the map
const THEMES := {
	"den": {"name": "RAPTOR DEN", "text": "It smells of blood and old bones down here.",
		"floor": [Color(0.1, 0.09, 0.07), Color(0.27, 0.23, 0.18)], "wall": Color(0.08, 0.07, 0.06), "face": Color(0.36, 0.3, 0.23),
		"accent": Color(0.28, 0.42, 0.22), "glow": Color(0.35, 0.9, 0.8), "pool": ["raptor", "raptor", "compy"]},
	"swamp": {"name": "SUNKEN HOLLOW", "text": "Water drips in the dark. Something is breathing.",
		"floor": [Color(0.06, 0.08, 0.06), Color(0.18, 0.22, 0.16)], "wall": Color(0.05, 0.06, 0.05), "face": Color(0.22, 0.28, 0.2),
		"accent": Color(0.2, 0.36, 0.22), "glow": Color(0.55, 1.0, 0.5), "pool": ["raptor", "diplo", "diplo"]},
	"ember": {"name": "EMBER DEEP", "text": "The rock is warm. The mountain's heart beats below.",
		"floor": [Color(0.08, 0.06, 0.06), Color(0.21, 0.16, 0.14)], "wall": Color(0.06, 0.045, 0.04), "face": Color(0.28, 0.2, 0.17),
		"accent": Color(0.9, 0.32, 0.08), "glow": Color(1.0, 0.45, 0.15), "pool": ["raptor", "ankylo", "raptor"]},
	"frost": {"name": "FROST CRYPT", "text": "Ice creaks in the walls. Old things sleep here.",
		"floor": [Color(0.1, 0.12, 0.16), Color(0.3, 0.36, 0.45)], "wall": Color(0.07, 0.08, 0.11), "face": Color(0.38, 0.46, 0.56),
		"accent": Color(0.6, 0.82, 0.96), "glow": Color(0.55, 0.75, 1.0), "pool": ["raptor", "snowrunner", "raptor"]},
}
const SCENES := {
	"raptor": "res://scenes/raptor.tscn", "compy": "res://scenes/compy.tscn", "diplo": "res://scenes/diplo.tscn",
	"ankylo": "res://scenes/ankylo.tscn", "snowrunner": "res://scenes/snowrunner.tscn", "boss": "res://scenes/predator.tscn",
}

var theme := "den"
var tier := 1 ## deeper dungeons have tougher beasts
var grid := PackedByteArray() ## 1 = floor
var rooms: Array[Rect2i] = []
var start_room := 0
var boss_room := 0
var boss: Animal
var spawned: Array = [] ## beasts, props and exits living in the actors layer
var explored: Image
var map_texture: ImageTexture
var _view: Image
var _exit_open := false
var _reveal := 0.0
var _rng := RandomNumberGenerator.new()

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var actors: Node2D = get_node("../Actors")


## Generates everything; call once the dungeon is in the tree.
func build(seed_value: int) -> void:
	_rng.seed = seed_value
	_carve()
	_draw_ground()
	_build_walls()
	_populate()
	_bake_navigation()
	_build_map()


func rect() -> Rect2:
	return Rect2(global_position, Vector2(SIZE * CELL))


func cell_center(c: Vector2i) -> Vector2:
	return global_position + (Vector2(c) + Vector2(0.5, 0.5)) * CELL


func start_position() -> Vector2:
	return cell_center(_center(rooms[start_room])) + Vector2(0, 30)


func is_floor(c: Vector2i) -> bool:
	return c.x >= 0 and c.y >= 0 and c.x < SIZE.x and c.y < SIZE.y and grid[c.y * SIZE.x + c.x] == 1


func _center(r: Rect2i) -> Vector2i:
	return r.position + r.size / 2


func _carve() -> void:
	grid.resize(SIZE.x * SIZE.y)
	grid.fill(0)
	for attempt in 400:
		if rooms.size() >= 9:
			break
		var w := _rng.randi_range(6, 12)
		var h := _rng.randi_range(5, 9)
		var room := Rect2i(_rng.randi_range(2, SIZE.x - w - 2), _rng.randi_range(3, SIZE.y - h - 2), w, h)
		var free := true
		for other in rooms:
			if other.grow(2).intersects(room):
				free = false
				break
		if free:
			rooms.append(room)
	rooms.sort_custom(func(a: Rect2i, b: Rect2i) -> bool: return a.position.x < b.position.x)
	for room in rooms:
		_fill(room)
	for i in rooms.size() - 1:
		_tunnel(_center(rooms[i]), _center(rooms[i + 1]))
	for i in 2: # a few loops, so there is more than one way around
		var a := _rng.randi() % rooms.size()
		var b := _rng.randi() % rooms.size()
		if a != b:
			_tunnel(_center(rooms[a]), _center(rooms[b]))
	start_room = 0
	var dist := _distances(_center(rooms[start_room]))
	for i in rooms.size():
		if dist.get(_center(rooms[i]), 0) > dist.get(_center(rooms[boss_room]), 0):
			boss_room = i


func _fill(r: Rect2i) -> void:
	for y in range(r.position.y, r.end.y):
		for x in range(r.position.x, r.end.x):
			grid[y * SIZE.x + x] = 1


func _tunnel(a: Vector2i, b: Vector2i) -> void:
	var corner := Vector2i(b.x, a.y) if _rng.randf() < 0.5 else Vector2i(a.x, b.y)
	for leg in [[a, corner], [corner, b]]:
		var p: Vector2i = leg[0]
		var step: Vector2i = (leg[1] - p).sign()
		while true:
			_fill(Rect2i(p, Vector2i(2, 2)))
			if p == leg[1]:
				break
			p += step


## Steps from one cell to every floor cell it connects to.
func _distances(from: Vector2i) -> Dictionary:
	var dist := {from: 0}
	var queue: Array[Vector2i] = [from]
	var i := 0
	while i < queue.size():
		var c := queue[i]
		i += 1
		for d in [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.UP, Vector2i.DOWN]:
			var n: Vector2i = c + d
			if is_floor(n) and not dist.has(n):
				dist[n] = dist[c] + 1
				queue.append(n)
	return dist


func _draw_ground() -> void:
	var bytes := grid.duplicate()
	for i in bytes.size():
		bytes[i] *= 255
	var ground := ColorRect.new()
	ground.name = "Ground"
	ground.size = Vector2(SIZE * CELL)
	ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var look: Dictionary = THEMES[theme]
	var material := ShaderMaterial.new()
	material.shader = load("res://shaders/dungeon.gdshader")
	material.set_shader_parameter("grid", ImageTexture.create_from_image(Image.create_from_data(SIZE.x, SIZE.y, false, Image.FORMAT_L8, bytes)))
	var noise := NoiseTexture2D.new()
	noise.seamless = true
	noise.noise = FastNoiseLite.new()
	noise.noise.frequency = 0.03
	noise.noise.seed = _rng.randi()
	material.set_shader_parameter("noise", noise)
	material.set_shader_parameter("cells", Vector2(SIZE))
	material.set_shader_parameter("floor_dark", look.floor[0])
	material.set_shader_parameter("floor_light", look.floor[1])
	material.set_shader_parameter("wall_top", look.wall)
	material.set_shader_parameter("wall_face", look.face)
	material.set_shader_parameter("accent", look.accent)
	ground.material = material
	add_child(ground)


## Solid rock blocks movement; whole rows of it are merged into a few long boxes.
func _build_walls() -> void:
	var body := StaticBody2D.new()
	body.name = "Walls"
	body.add_to_group("dungeon_walls")
	add_child(body)
	for y in SIZE.y:
		var run_start := -1
		for x in SIZE.x + 1:
			var wall := x < SIZE.x and not is_floor(Vector2i(x, y))
			if wall and run_start < 0:
				run_start = x
			elif not wall and run_start >= 0:
				var shape := CollisionShape2D.new()
				shape.shape = RectangleShape2D.new()
				shape.shape.size = Vector2((x - run_start) * CELL, CELL)
				shape.position = Vector2((run_start + x) * CELL / 2.0, (y + 0.5) * CELL)
				body.add_child(shape)
				run_start = -1


func _bake_navigation() -> void:
	var region := NavigationRegion2D.new()
	region.name = "Navigation"
	var walkable := NavigationPolygon.new()
	var size := Vector2(SIZE * CELL)
	walkable.add_outline(PackedVector2Array([Vector2.ZERO, Vector2(size.x, 0), size, Vector2(0, size.y)]))
	walkable.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	walkable.parsed_collision_mask = 1
	walkable.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	walkable.source_geometry_group_name = &"dungeon_walls"
	walkable.agent_radius = 7.0
	region.navigation_polygon = walkable
	add_child(region)
	region.bake_navigation_polygon(false)


func _random_cell(room: Rect2i) -> Vector2i:
	return Vector2i(_rng.randi_range(room.position.x + 1, room.end.x - 2), _rng.randi_range(room.position.y + 1, room.end.y - 2))


func _populate() -> void:
	var look: Dictionary = THEMES[theme]
	for i in rooms.size():
		var room := rooms[i]
		# every room has something glowing in a corner
		var corner := Vector2i(room.position.x + 1 if _rng.randf() < 0.5 else room.end.x - 2, room.position.y + 1)
		var glow := PointLight2D.new()
		glow.texture = load("res://world/light_radial.tres")
		glow.color = look.glow
		glow.energy = 0.8
		glow.texture_scale = 2.4
		glow.set_script(load("res://scripts/flicker.gd"))
		glow.position = cell_center(corner) - global_position
		add_child(glow)
		var fungi: Node2D = load("res://scenes/mushrooms.tscn").instantiate()
		fungi.position = cell_center(corner)
		fungi.modulate = look.glow.lightened(0.2)
		_add(fungi)
		if i == start_room:
			continue
		for k in _rng.randi_range(2, 3) + tier - 1:
			_spawn_beast(look.pool[_rng.randi() % look.pool.size()], _random_cell(room), 0)
		if i != boss_room and _rng.randf() < 0.2 + 0.05 * tier:
			_spawn_beast("raptor", _random_cell(room), 1)
	boss = _spawn_beast("boss", _center(rooms[boss_room]), 2)
	# a hoard of trophies in a quiet room
	var hoard := _rng.randi_range(1, rooms.size() - 1)
	if hoard == boss_room:
		hoard = 1 if boss_room != 1 else rooms.size() - 1
	for k in 2:
		_add(Loot.spawn(actors, cell_center(_random_cell(rooms[hoard])), Loot.roll(clampi(tier + 1, 1, 5), -1, 1)))
	var story := get_tree().get_first_node_in_group("story") as Story
	if story and not story.found.has("star") and rooms.size() > 2:
		var site: Node2D = load("res://scenes/lore_site.tscn").instantiate()
		site.id = "star"
		site.position = cell_center(_random_cell(rooms[rooms.size() / 2]))
		_add(site)
	_exit(_center(rooms[start_room]) + Vector2i(0, -1))


func _add(node: Node2D) -> Node2D:
	if node.get_parent() == null:
		actors.add_child(node)
	spawned.append(node)
	return node


func _spawn_beast(kind: String, cell: Vector2i, rank: int) -> Animal:
	var beast: Animal = load(SCENES[kind]).instantiate()
	beast.position = cell_center(cell)
	_add(beast)
	beast.hostile = true
	beast.rank = rank
	var toughness := 1.0 + 0.5 * (tier - 1)
	beast.power = 1.0 + 0.25 * (tier - 1)
	if rank == 1:
		toughness *= 3.0
		beast.power *= 1.5
		beast.title = "ELITE"
		beast.sprite.scale *= 1.25
		beast.sprite.self_modulate = Color(1.35, 1.1, 0.6)
	elif rank == 2:
		toughness *= 4.0
		beast.power *= 1.3
		beast.title = "CAVE TYRANT"
		beast.sprite.scale *= 1.5
		beast.sprite.self_modulate = Color(1.4, 0.75, 0.65)
	beast.max_health *= toughness
	beast.health = beast.max_health
	return beast


func _exit(cell: Vector2i) -> void:
	var door: Node2D = load("res://scenes/dungeon_entrance.tscn").instantiate()
	door.exit = true
	door.position = cell_center(cell)
	_add(door)


func _build_map() -> void:
	explored = Image.create_empty(SIZE.x, SIZE.y, false, Image.FORMAT_L8)
	_view = Image.create_empty(SIZE.x, SIZE.y, false, Image.FORMAT_RGBA8)
	map_texture = ImageTexture.create_from_image(_view)
	reveal(start_position())


func reveal(pos: Vector2) -> void:
	var center := Vector2i(((pos - global_position) / CELL).floor())
	var look: Dictionary = THEMES[theme]
	for dy in range(-REVEAL, REVEAL + 1):
		for dx in range(-REVEAL, REVEAL + 1):
			var c := center + Vector2i(dx, dy)
			if dx * dx + dy * dy > REVEAL * REVEAL or c.x < 0 or c.y < 0 or c.x >= SIZE.x or c.y >= SIZE.y:
				continue
			explored.set_pixelv(c, Color.WHITE)
			_view.set_pixelv(c, (look.floor[1] as Color).lightened(0.25) if is_floor(c) else Color(0, 0, 0, 0))
	map_texture.update(_view)


func explored_at(pos: Vector2) -> bool:
	var c := Vector2i(((pos - global_position) / CELL).floor())
	return c.x >= 0 and c.y >= 0 and c.x < SIZE.x and c.y < SIZE.y and explored.get_pixelv(c).r > 0.5


func _process(delta: float) -> void:
	if not _exit_open and not is_instance_valid(boss):
		# the tyrant is dead: a second way out opens where it ruled
		_exit_open = true
		_exit(Vector2i(_center(rooms[boss_room]).x, rooms[boss_room].position.y))
		var hud := get_tree().get_first_node_in_group("hud")
		if hud:
			hud.narrate("", "The tyrant falls. A way out opens.")
	_reveal -= delta
	if _reveal <= 0.0 and rect().has_point(player.global_position):
		_reveal = 0.2
		reveal(player.global_position)


func _exit_tree() -> void:
	for node in spawned:
		if is_instance_valid(node):
			node.queue_free()
	# whatever was dropped down here stays down here
	for drop: Node2D in get_tree().get_nodes_in_group("loot"):
		if rect().has_point(drop.global_position):
			drop.queue_free()
