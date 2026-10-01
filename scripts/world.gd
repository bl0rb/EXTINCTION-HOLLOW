class_name World
extends Node2D
## The overworld, built when the game starts (GAME_SPEC §150). Every new age rolls a new world: where the regions meet,
## how the river runs and where it can be crossed, the cliff with the cave and the ramp, the pond and the creek,
## the paths, the volcano - and everything that grows and lies around. Seed 0 is the classic world of the first age.

const W := 3072.0
const H := 1536.0
const JH := 960.0 ## jungle and steppe reach down to the river
const POND_R := Vector2(118, 56)
const PATH_WIDTH := {"trail": 0.0, "branch": -2.0, "up": -3.0, "east_path": -3.0, "pass": -3.0, "north": -5.0, "north_end": -5.0, "south": -3.0}
const CLASSIC := {
	"west": 1300.0, "east": 2304.0, "ridge": 820.0, "fords": [600.0, 1760.0], "cliff_end": 1330.0, "ramp": Vector2(1008, 1112),
	"river": [1010.0, 28.0, 170.0, 0.0, 12.0, 61.0, 1.3], "edge": [250.0, 6.0, 53.0, 0.0, 4.0, 17.0, 1.0],
	"cave_x": 640.0, "pond": Vector2(300, 372), "volcano": Vector2(2690, 300), "skeleton": Vector2(1760, 420), "wash_x": 1900.0,
	"ice_ponds": [Vector4(2560, 1180, 70, 34), Vector4(2860, 1390, 90, 40), Vector4(2980, 1040, 50, 26)],
	"creek": [Vector2(250, -4), Vector2(228, 60), Vector2(268, 128), Vector2(246, 190), Vector2(300, 256)],
	"paths": {
		"trail": [Vector2(640, 330), Vector2(628, 420), Vector2(660, 520), Vector2(640, 620), Vector2(590, 720), Vector2(610, 840), Vector2(580, 960)],
		"branch": [Vector2(660, 520), Vector2(780, 560), Vector2(900, 600), Vector2(1040, 560), Vector2(1060, 470), Vector2(1060, 330)],
		"up": [Vector2(1060, 330), Vector2(1060, 240), Vector2(1030, 170), Vector2(1080, 90)],
		"east_path": [Vector2(1040, 560), Vector2(1240, 610), Vector2(1500, 650), Vector2(1800, 610), Vector2(2100, 670), Vector2(2304, 640)],
		"pass": [Vector2(2304, 640), Vector2(2450, 720), Vector2(2560, 830), Vector2(2640, 960)],
		"north": [Vector2(1080, 90), Vector2(1330, 200), Vector2(1600, 260), Vector2(1900, 190), Vector2(2304, 230)],
		"north_end": [Vector2(2304, 230), Vector2(2480, 330)],
	},
	"trees": [
		Vector3(40, 70, 0), Vector3(130, 150, 1), Vector3(80, 232, 0), Vector3(380, 80, 1), Vector3(460, 196, 0),
		Vector3(560, 60, 1), Vector3(690, 130, 0), Vector3(820, 58, 1), Vector3(900, 200, 0), Vector3(1180, 80, 0),
		Vector3(1250, 200, 1), Vector3(960, 110, 1), Vector3(600, 226, 1), Vector3(330, 226, 0),
		Vector3(30, 430, 1), Vector3(62, 560, 0), Vector3(22, 700, 1), Vector3(70, 850, 0), Vector3(40, 955, 1),
		Vector3(1236, 400, 0), Vector3(1190, 800, 1),
		Vector3(200, 952, 0), Vector3(330, 930, 1), Vector3(460, 955, 0), Vector3(760, 950, 1), Vector3(880, 928, 0),
		Vector3(1010, 955, 1), Vector3(1120, 938, 0),
		Vector3(880, 712, 0), Vector3(420, 700, 1), Vector3(262, 580, 0), Vector3(770, 420, 1), Vector3(1150, 640, 1), Vector3(160, 760, 0),
	],
	"rocks": [
		Vector3(470, 342, 1), Vector3(842, 338, 0), Vector3(440, 446, 0), Vector3(168, 452, 1), Vector3(722, 474, 0),
		Vector3(540, 604, 1), Vector3(962, 782, 0), Vector3(300, 764, 1), Vector3(1132, 472, 0), Vector3(700, 862, 0),
		Vector3(1180, 300, 1), Vector3(760, 170, 0), Vector3(196, 420, 0), Vector3(408, 404, 0), Vector3(250, 434, 0),
	],
	"dead_trees": [Vector3(1420, 330, 0), Vector3(1560, 820, 1), Vector3(1690, 150, 1), Vector3(1840, 470, 0), Vector3(2020, 880, 0),
		Vector3(2150, 360, 1), Vector3(1350, 560, 1), Vector3(1880, 300, 0)],
	"boulders": [Vector3(1460, 470, 1), Vector3(1480, 490, 0), Vector3(1640, 560, 1), Vector3(1720, 740, 0), Vector3(2060, 520, 1),
		Vector3(2090, 540, 0), Vector3(2200, 780, 1), Vector3(1600, 380, 0), Vector3(1880, 870, 1), Vector3(2260, 440, 0), Vector3(1380, 120, 1)],
	"mushrooms": [Vector2(192, 612), Vector2(868, 468), Vector2(1108, 862), Vector2(482, 802), Vector2(560, 206), Vector2(1000, 640)],
	"lizards": [Vector2(420, 640), Vector2(860, 660), Vector2(250, 520), Vector2(1080, 760), Vector2(700, 760), Vector2(560, 480)],
	"predators": [Vector2(900, 830), Vector2(1950, 780)],
	"beams": [Vector2(430, 610), Vector2(860, 780), Vector2(170, 830), Vector2(1010, 400), Vector2(620, 150)],
	"steppe_moons": [Vector2(1560, 260), Vector2(1760, 720), Vector2(2080, 300), Vector2(2140, 820)],
	"snow_lights": [Vector2(2480, 1000), Vector2(2860, 1060), Vector2(2560, 1380), Vector2(2940, 1400)],
	"ash_glows": [Vector2(2480, 560), Vector2(2940, 520)],
	"glints": [420.0, 1300.0, 2050.0],
	"lore": {"bones": Vector2(240, 700), "claws": Vector2(820, 170), "giant": Vector2(1760, 452), "stones": Vector2(1500, 1180),
		"tracks": Vector2(420, 1380), "glass": Vector2(2900, 560), "ice": Vector2(2760, 1300)},
}
const SCENES := { ## loaded when needed: some of these scenes refer back to classes that know the world
	"tree": "res://scenes/tree.tscn", "rock_large": "res://scenes/rock_large.tscn", "rock_small": "res://scenes/rock_small.tscn",
	"mushrooms": "res://scenes/mushrooms.tscn", "deadtree": "res://scenes/deadtree.tscn", "fern": "res://scenes/fern.tscn",
	"reed": "res://scenes/reed.tscn", "grass": "res://scenes/grass.tscn", "pine": "res://scenes/pine.tscn",
	"lizard": "res://scenes/lizard.tscn", "lava_pool": "res://scenes/lava_pool.tscn",
	"dungeon_entrance": "res://scenes/dungeon_entrance.tscn", "lore_site": "res://scenes/lore_site.tscn",
}

var seed_value := 0
var params := {}
var main: Node2D
var actors: Node2D
var _spacing := Spacing.new() ## trees, rocks and other solid things keep their distance


## A grid of points for quick "is anything too close" checks.
class Spacing:
	var cells := {}

	func add(p: Vector2) -> void:
		var key := Vector2i((p / 32.0).floor())
		if not cells.has(key):
			cells[key] = []
		cells[key].append(p)

	func is_free(p: Vector2, dist: float) -> bool:
		var key := Vector2i((p / 32.0).floor())
		var reach := ceili(dist / 32.0)
		for dy in range(-reach, reach + 1):
			for dx in range(-reach, reach + 1):
				for q: Vector2 in cells.get(key + Vector2i(dx, dy), []):
					if p.distance_to(q) < dist:
						return false
		return true


func _ready() -> void:
	Settings.ensure()
	add_to_group("world_map")
	main = get_parent()
	actors = main.get_node("Actors")
	seed_value = Net.world_seed if Net.in_game else SaveGame.read("world", "seed", 0)
	params = CLASSIC.duplicate(true) if seed_value == 0 else roll(seed_value)
	Biomes.configure(params)
	_paint_ground()
	_build_terrain()
	_place_landmarks()
	_grow()
	_fill_the_air()
	_set_up_systems()


## A new world from a seed: the same seed always gives the same world.
static func roll(world_seed: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = world_seed
	var p := CLASSIC.duplicate(true)
	var west := rng.randf_range(1180, 1400)
	var east := rng.randf_range(maxf(west + 820, 2180), 2420)
	p.west = west
	p.east = east
	p.ridge = rng.randf_range(720, 900)
	p.river = [rng.randf_range(985, 1030), rng.randf_range(16, 32), rng.randf_range(130, 220), rng.randf() * TAU,
		rng.randf_range(6, 14), rng.randf_range(48, 75), rng.randf() * TAU]
	p.edge = [rng.randf_range(225, 280), rng.randf_range(3, 8), rng.randf_range(40, 70), rng.randf() * TAU,
		rng.randf_range(2, 5), rng.randf_range(12, 22), rng.randf() * TAU]
	p.cliff_end = west + rng.randf_range(-10, 60)
	p.fords = [rng.randf_range(320, west - 220), rng.randf_range(west + 180, east - 180)]
	# the cave, the ramp and the pond sit along the cliff, well apart
	var cave_x := rng.randf_range(340, p.cliff_end - 460)
	var ramp_x := cave_x
	while absf(ramp_x + 52.0 - cave_x) < 260.0:
		ramp_x = rng.randf_range(150, p.cliff_end - 170)
	var pond_x := cave_x
	for attempt in 200:
		pond_x = rng.randf_range(180, p.cliff_end - 220)
		if absf(pond_x - cave_x) > 240.0 and absf(pond_x - ramp_x - 52.0) > 200.0:
			break
	p.cave_x = cave_x
	p.ramp = Vector2(ramp_x, ramp_x + 104.0)
	Biomes.configure(p)
	p.pond = Vector2(pond_x, Biomes.bottom(pond_x) + 56.0)
	p.volcano = Vector2(rng.randf_range(east + 220, W - 240), rng.randf_range(250, p.ridge - 250))
	p.skeleton = Vector2(rng.randf_range(west + 200, east - 220), rng.randf_range(360, 760))
	p.wash_x = rng.randf_range(west + 300, east - 250)
	p.ice_ponds = []
	for i in 3:
		p.ice_ponds.append(Vector4(rng.randf_range(east + 120, W - 120), rng.randf_range(p.ridge + 160, H - 90), rng.randf_range(50, 90), rng.randf_range(26, 40)))
	var top := Biomes.edge(pond_x)
	p.creek = []
	for i in 5:
		var k := i / 4.0
		p.creek.append(Vector2(pond_x + (rng.randf_range(-40, 40) if i < 4 else 0.0) + (1.0 - k) * rng.randf_range(-40, 40), -4.0 + k * (top + 10.0)))
	# paths: from the cave down to the first ford, up the ramp, east across the steppe and over the ridge, north to the volcano
	var cave_front := Vector2(cave_x, Biomes.bottom(cave_x) + 12.0)
	var ford_top := Vector2(p.fords[0], Biomes.river_y(p.fords[0]) - Biomes.river_half(p.fords[0]) - 14.0)
	var trail := [cave_front]
	for i in range(1, 6):
		trail.append(cave_front.lerp(ford_top, i / 6.0) + Vector2(rng.randf_range(-36, 36), 0))
	trail.append(ford_top)
	var ramp_mid := ramp_x + 52.0
	var ramp_foot := Vector2(ramp_mid, Biomes.bottom(ramp_mid) + 18.0)
	var fork: Vector2 = trail[2]
	var branch := [fork, fork.lerp(ramp_foot, 0.5) + Vector2(0, rng.randf_range(-30, 30)), ramp_foot, Vector2(ramp_mid, Biomes.bottom(ramp_mid) - 4.0)]
	var plateau_end := Vector2(clampf(ramp_mid + rng.randf_range(-60, 80), 60, p.cliff_end - 60), 90)
	var up := [Vector2(ramp_mid, Biomes.bottom(ramp_mid) - 4.0), Vector2(ramp_mid, Biomes.edge(ramp_mid) - 10.0), plateau_end]
	var east_y := rng.randf_range(560, p.ridge - 110)
	var start_east: Vector2 = branch[1]
	var east_path := [start_east]
	for i in range(1, 5):
		var k := i / 5.0
		east_path.append(Vector2(lerpf(start_east.x, east, k), lerpf(start_east.y, east_y, k) + rng.randf_range(-40, 40)))
	east_path.append(Vector2(east, east_y))
	var pass_path := [Vector2(east, east_y), Vector2(east + 140, p.ridge - 90), Vector2(east + 250, p.ridge + 10), Vector2(east + 330, p.ridge + 140)]
	var north := [plateau_end, Vector2(west, rng.randf_range(160, 230)), Vector2((west + east) / 2.0, rng.randf_range(200, 280)), Vector2(east, rng.randf_range(200, 260))]
	var north_end := [north[-1], Vector2(east + 170, p.volcano.y + 30.0)]
	var ford2_top := Vector2(p.fords[1], Biomes.river_y(p.fords[1]) - Biomes.river_half(p.fords[1]) - 14.0)
	var nearest: Vector2 = east_path[0]
	for q: Vector2 in east_path:
		if absf(q.x - p.fords[1]) < absf(nearest.x - p.fords[1]):
			nearest = q
	p.paths = {"trail": trail, "branch": branch, "up": up, "east_path": east_path, "pass": pass_path, "north": north, "north_end": north_end,
		"south": [nearest, nearest.lerp(ford2_top, 0.5) + Vector2(rng.randf_range(-30, 30), 0), ford2_top]}
	p.merge({"trees": [], "rocks": [], "dead_trees": [], "boulders": [], "mushrooms": [], "lizards": [], "predators": [], "beams": [],
		"steppe_moons": [], "snow_lights": [], "ash_glows": [], "glints": [], "lore": {}}, true)
	p.random = true
	return p


func line_dist(p: Vector2, line: Array) -> float:
	var best := INF
	for i in line.size() - 1:
		best = minf(best, p.distance_to(Geometry2D.get_closest_point_to_segment(p, line[i], line[i + 1])))
	return best


func near_path(p: Vector2, margin: float) -> bool:
	for line: Array in params.paths.values():
		if line_dist(p, line) < margin:
			return true
	return false


func near_water(p: Vector2) -> bool:
	return absf(p.y - Biomes.river_y(p.x)) < Biomes.river_half(p.x) + 12.0


func in_cliff(p: Vector2, margin := 8.0) -> bool:
	return p.x < Biomes.CLIFF_END and p.y > Biomes.edge(p.x) - margin and p.y < Biomes.bottom(p.x) + margin


func spawn(key: String, pos: Vector2, props := {}) -> Node2D:
	var node: Node2D = load(SCENES[key]).instantiate()
	node.position = pos
	for k: String in props:
		node.set(k, props[k])
	actors.add_child(node)
	return node


func _paint_ground() -> void:
	var material: ShaderMaterial = main.get_node("Ground").material
	var ramp: Vector2 = params.ramp
	material.set_shader_parameter("borders", Vector3(params.west, params.east, params.ridge))
	material.set_shader_parameter("river_a", Vector4(params.river[0], params.river[1], params.river[2], params.river[3]))
	material.set_shader_parameter("river_b", Vector3(params.river[4], params.river[5], params.river[6]))
	material.set_shader_parameter("fords", Vector2(params.fords[0], params.fords[1]))
	material.set_shader_parameter("edge_a", Vector4(params.edge[0], params.edge[1], params.edge[2], params.edge[3]))
	material.set_shader_parameter("edge_b", Vector4(params.edge[4], params.edge[5], params.edge[6], params.cliff_end))
	material.set_shader_parameter("ramp", Vector2(ramp.x - 18.0, ramp.y + 18.0))
	material.set_shader_parameter("pond", Vector4(params.pond.x, params.pond.y, POND_R.x, POND_R.y))
	material.set_shader_parameter("creek", PackedVector2Array(params.creek))
	material.set_shader_parameter("wash_x", params.wash_x)
	material.set_shader_parameter("ice_ponds", PackedVector4Array(params.ice_ponds))
	var segments := PackedVector4Array()
	var widths := PackedFloat32Array()
	for key: String in params.paths:
		var line: Array = params.paths[key]
		for i in line.size() - 1:
			segments.append(Vector4(line[i].x, line[i].y, line[i + 1].x, line[i + 1].y))
			widths.append(PATH_WIDTH[key])
	material.set_shader_parameter("paths", segments)
	material.set_shader_parameter("path_widths", widths)
	material.set_shader_parameter("path_count", segments.size())


## The cliff (except the ramp), the river (except the fords), the pond and the world's borders block the way.
func _build_terrain() -> void:
	var terrain: StaticBody2D = main.get_node("Terrain")
	var ramp: Vector2 = params.ramp
	for span in [Vector2(0, ramp.x), Vector2(ramp.y, Biomes.CLIFF_END - 30.0)]:
		if span.y - span.x < 16.0:
			continue
		var xs := []
		var x: float = span.x
		while x < span.y:
			xs.append(x)
			x += 16.0
		xs.append(span.y)
		var pts := PackedVector2Array()
		for px: float in xs:
			pts.append(Vector2(px, Biomes.edge(px) + 3.0))
		xs.reverse()
		for px: float in xs:
			pts.append(Vector2(px, Biomes.bottom(px) - 3.0))
		_collide(terrain, "Cliff", pts)
	var fords: Array = params.fords
	for span in [Vector2(0, fords[0] - Biomes.FORD_HALF), Vector2(fords[0] + Biomes.FORD_HALF, fords[1] - Biomes.FORD_HALF),
			Vector2(fords[1] + Biomes.FORD_HALF, Biomes.EAST - 24.0)]:
		var top := PackedVector2Array()
		var low := PackedVector2Array()
		var x: float = span.x
		while true:
			var half := Biomes.river_half(x) - 4.0
			top.append(Vector2(x, Biomes.river_y(x) - half))
			low.append(Vector2(x, Biomes.river_y(x) + half))
			if x >= span.y:
				break
			x = minf(x + 12.0, span.y)
		low.reverse()
		_collide(terrain, "River", top + low)
	var pond_pts := PackedVector2Array()
	for i in 24:
		pond_pts.append(params.pond + Vector2.from_angle(TAU * i / 24.0) * (POND_R - Vector2(8, 6)))
	_collide(terrain, "Pond", pond_pts)
	for r in [Rect2(-16, 0, 16, H), Rect2(W, 0, 16, H), Rect2(0, -16, W, 16), Rect2(0, H, W, 16)]:
		var shape := CollisionShape2D.new()
		shape.name = "Border"
		shape.shape = RectangleShape2D.new()
		shape.shape.size = r.size
		shape.position = r.get_center()
		terrain.add_child(shape)
	# the cliff edge keeps the cave light off the plateau; the grown cave sticks out above it
	var cave_x: float = params.cave_x
	var edge_line := PackedVector2Array()
	for i in int(Biomes.CLIFF_END / 16.0) + 1:
		var x := i * 16.0
		var over_cave := clampf(1.0 - absf(x - cave_x) / 110.0, 0.0, 1.0)
		edge_line.append(Vector2(x, lerpf(Biomes.edge(x) + 1.0, Biomes.bottom(cave_x) - 140.0, minf(over_cave * 2.0, 1.0))))
	var occluder: LightOccluder2D = main.get_node("CliffOccluder")
	occluder.occluder = OccluderPolygon2D.new()
	occluder.occluder.closed = false
	occluder.occluder.polygon = edge_line


func _collide(terrain: StaticBody2D, what: String, pts: PackedVector2Array) -> void:
	var poly := CollisionPolygon2D.new()
	poly.name = what
	poly.polygon = pts
	terrain.add_child(poly)


func _place_landmarks() -> void:
	var cave_pos := Vector2(params.cave_x, Biomes.bottom(params.cave_x) + 6.0)
	main.get_node("Cave").position = cave_pos
	actors.get_node("Player").position = cave_pos
	main.get_node("Volcano").position = params.volcano
	main.get_node("Skeleton").position = params.skeleton
	main.get_node("Pond").position = params.pond
	main.get_node("River").length = Biomes.EAST - 30.0
	var pond_x: float = params.pond.x
	main.get_node("Waterfall").position = Vector2(pond_x, Biomes.edge(pond_x) + 52.0)
	main.get_node("Mist").position = Vector2(pond_x, Biomes.edge(pond_x) + 98.0)


## Everything that grows and lies around, and the first animals.
func _grow() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value * 7919 + 3
	var random: bool = params.get("random", false)
	if random:
		_scatter_random(rng)
	var west: float = params.west
	for i in params.lizards.size():
		spawn("lizard", params.lizards[i]).name = "Lizard%d" % (i + 1)
	for t: Vector3 in params.trees:
		spawn("tree", Vector2(t.x, t.y), {"variant": int(t.z)})
		_spacing.add(Vector2(t.x, t.y))
	for r: Vector3 in params.rocks:
		spawn("rock_large" if r.z > 0 else "rock_small", Vector2(r.x, r.y))
		_spacing.add(Vector2(r.x, r.y))
	for m: Vector2 in params.mushrooms:
		spawn("mushrooms", m)
		_spacing.add(m)
	actors.get_node("Predator").position = params.predators[0]
	actors.get_node("Predator2").position = params.predators[1]
	for t: Vector3 in params.dead_trees:
		spawn("deadtree", Vector2(t.x, t.y), {"variant": int(t.z)})
		_spacing.add(Vector2(t.x, t.y))
	for r: Vector3 in params.boulders:
		spawn("rock_large" if r.z > 0 else "rock_small", Vector2(r.x, r.y))
		_spacing.add(Vector2(r.x, r.y))

	# ferns in clumps, away from paths, water, the cliff and the cave
	var fern_rng := RandomNumberGenerator.new()
	fern_rng.seed = 7 if not random else seed_value * 31 + 7
	var clumps := FastNoiseLite.new()
	clumps.frequency = 0.01
	clumps.seed = 0 if not random else seed_value
	var cave_front := Vector2(params.cave_x, Biomes.bottom(params.cave_x) + 10.0)
	var paths: Dictionary = params.paths
	var ferns := Spacing.new()
	var fern_count := 0
	for i in 6000:
		if fern_count >= 230:
			break
		var p := Vector2(fern_rng.randf_range(12, west - 20), fern_rng.randf_range(20, JH - 4))
		if p.y > Biomes.river_y(p.x) - Biomes.river_half(p.x) - 18.0:
			continue
		if clumps.get_noise_2dv(p) < 0.05 or (p.x > west - 150.0 and fern_rng.randf() < (p.x - west + 150.0) / 150.0):
			continue
		if p.y > Biomes.edge(p.x) - 6 and p.y < Biomes.bottom(p.x) + 8:
			continue
		if line_dist(p, paths.trail) < 18 or line_dist(p, paths.branch) < 16 or line_dist(p, paths.up) < 16 or line_dist(p, params.creek) < 12:
			continue
		if ((p - params.pond) / (POND_R + Vector2(2, 2))).length() < 1.0 or p.distance_to(cave_front) < 56:
			continue
		if _spacing.is_free(p, 18) and ferns.is_free(p, 11):
			ferns.add(p)
			fern_count += 1
			spawn("fern", p, {"frame": fern_rng.randi() % 3, "flip_h": fern_rng.randf() < 0.5})

	# reeds along the pond shore (not under the cliff)
	for i in 22:
		var a := lerpf(-0.15 * PI, 1.15 * PI, (i + fern_rng.randf() * 0.6) / 22.0)
		var p: Vector2 = params.pond + Vector2(cos(a) * (POND_R.x + fern_rng.randf_range(2, 12)), sin(a) * (POND_R.y + fern_rng.randf_range(0, 8)))
		if p.y < Biomes.bottom(p.x) + 6:
			continue
		spawn("reed", p, {"frame": fern_rng.randi() % 3, "flip_h": fern_rng.randf() < 0.5})

	# dry grass in clumps across the steppe
	var grass := Spacing.new()
	var grass_count := 0
	for i in 8000:
		if grass_count >= 190:
			break
		var p := Vector2(fern_rng.randf_range(west - 40, Biomes.EAST - 20), fern_rng.randf_range(16, JH - 4))
		if p.y > Biomes.river_y(p.x) - Biomes.river_half(p.x) - 18.0:
			continue
		if clumps.get_noise_2dv(p * 0.8) < -0.05 or (p.x < west + 100.0 and fern_rng.randf() < (west + 100.0 - p.x) / 140.0):
			continue
		if line_dist(p, paths.east_path) < 16 or line_dist(p, paths.north) < 14 or p.distance_to(params.skeleton) < 60:
			continue
		if p.y > Biomes.edge(p.x) - 6 and p.y < Biomes.bottom(p.x) + 8:
			continue
		if _spacing.is_free(p, 16) and grass.is_free(p, 12):
			grass.add(p)
			grass_count += 1
			spawn("grass", p, {"frame": fern_rng.randi() % 3, "flip_h": fern_rng.randf() < 0.5})
	_grow_wilds()


## The regions beyond the valley (GAME_SPEC §27-§29, §114): every one looks and plays different.
func _grow_wilds() -> void:
	var brng := RandomNumberGenerator.new()
	brng.seed = 8 if not params.get("random", false) else seed_value * 17 + 8
	var fords: Array = params.fords
	var trail_end: Vector2 = params.paths.trail[-1]
	# river: reeds and stones on the bright banks, not at the fords
	for i in 150:
		var x := brng.randf_range(20, Biomes.EAST - 40)
		if absf(x - fords[0]) < Biomes.FORD_HALF + 10 or absf(x - fords[1]) < Biomes.FORD_HALF + 10 or absf(x - trail_end.x) < 30:
			continue
		var side := -1.0 if brng.randf() < 0.5 else 1.0
		var p := Vector2(x, Biomes.river_y(x) + side * (Biomes.river_half(x) + brng.randf_range(1, 9)))
		if i % 8 == 0:
			p.y += side * 10.0
			if _spacing.is_free(p, 22):
				spawn("rock_small", p)
				_spacing.add(p)
		else:
			spawn("reed", p, {"frame": brng.randi() % 3, "flip_h": brng.randf() < 0.5})
	var west: float = params.west
	var swamp_area := Rect2(10, 1060, west, 470)
	for t in place("deadtree", 18, swamp_area, Biomes.SWAMP, 40, brng):
		t.variant = brng.randi() % 2
		t.get_node("Sprite2D").self_modulate = Color(0.6, 0.72, 0.52)
	for m in place("mushrooms", 7, swamp_area, Biomes.SWAMP, 60, brng):
		m.modulate = Color(0.75, 1.0, 0.7)
	for r in place("reed", 90, swamp_area, Biomes.SWAMP, 10, brng, false):
		r.frame = brng.randi() % 3
		r.flip_h = brng.randf() < 0.5
	for f in place("fern", 50, swamp_area, Biomes.SWAMP, 14, brng, false):
		f.frame = brng.randi() % 3
		f.modulate = Color(0.7, 0.8, 0.62)
	var delta_area := Rect2(west, 1060, Biomes.EAST - west, 470)
	for t in place("tree", 9, delta_area, Biomes.RIVER, 60, brng):
		t.variant = brng.randi() % 2
	place("rock_large", 4, delta_area, Biomes.RIVER, 50, brng)
	for f in place("fern", 60, delta_area, Biomes.RIVER, 14, brng, false):
		f.frame = brng.randi() % 3
		f.flip_h = brng.randf() < 0.5
	for r in place("reed", 30, delta_area, Biomes.RIVER, 10, brng, false):
		r.frame = brng.randi() % 3
	var volcano_area := Rect2(Biomes.EAST + 10, 10, W - Biomes.EAST - 20, Biomes.RIDGE - 40)
	for t in place("deadtree", 14, volcano_area, Biomes.VOLCANO, 50, brng):
		t.variant = brng.randi() % 2
		t.get_node("Sprite2D").self_modulate = Color(0.32, 0.26, 0.24)
	for r in place("rock_large", 10, volcano_area, Biomes.VOLCANO, 50, brng):
		r.modulate = Color(0.6, 0.52, 0.5)
	for pool in place("lava_pool", 7, volcano_area, Biomes.VOLCANO, 70, brng):
		pool.get_node("Sprite2D").flip_h = brng.randf() < 0.5
	# the rocky ridge between fire and ice, with a pass where the path crosses
	var pass_x: float = params.paths.pass[2].x + 15.0
	var rx := Biomes.EAST + 26.0
	while rx < W - 20:
		if absf(rx - pass_x) > 55.0:
			var p := Vector2(rx, Biomes.RIDGE + brng.randf_range(-10, 10))
			spawn("rock_large" if brng.randf() < 0.7 else "rock_small", p)
			_spacing.add(p)
		rx += brng.randf_range(34, 52)
	var snow_area := Rect2(Biomes.EAST + 10, Biomes.RIDGE + 30, W - Biomes.EAST - 20, H - Biomes.RIDGE - 40)
	for t in place("pine", 28, snow_area, Biomes.SNOW, 46, brng):
		t.variant = brng.randi() % 2
	place("rock_large", 8, snow_area, Biomes.SNOW, 50, brng)
	place("rock_small", 8, snow_area, Biomes.SNOW, 40, brng)
	for t in place("deadtree", 4, snow_area, Biomes.SNOW, 50, brng):
		t.get_node("Sprite2D").self_modulate = Color(0.8, 0.86, 0.96)
	# a dungeon entrance in four regions, deeper ones are more dangerous
	for spec in [["den", 1, Rect2(80, 380, west - 200, 520), Biomes.JUNGLE], ["swamp", 2, swamp_area, Biomes.SWAMP],
			["ember", 3, volcano_area, Biomes.VOLCANO], ["frost", 3, snow_area, Biomes.SNOW]]:
		for door in place("dungeon_entrance", 1, spec[2], spec[3], 70, brng):
			door.theme = spec[0]
			door.tier = spec[1]
			door.name = "Dungeon_" + spec[0]
	# the places that tell the story
	var lore: Dictionary = params.lore
	if lore.is_empty():
		lore = _lore_spots(brng)
	for id: String in lore:
		spawn("lore_site", lore[id], {"id": id}).name = "Lore_" + id


## Scatters props over one biome, away from water, paths, the cliff, the volcano and each other.
func place(key: String, count: int, area: Rect2, biome: int, spacing: float, rng: RandomNumberGenerator, block := true) -> Array:
	var placed := []
	for i in count * 40:
		if placed.size() >= count:
			break
		var p := area.position + area.size * Vector2(rng.randf(), rng.randf())
		if Biomes.at(p) != biome or near_water(p) or in_cliff(p, 20.0) or p.distance_to(params.volcano) < 190:
			continue
		if near_path(p, 16.0) or not _spacing.is_free(p, spacing):
			continue
		if p.distance_to(Vector2(params.cave_x, Biomes.bottom(params.cave_x))) < 90.0 or ((p - params.pond) / (POND_R + Vector2(16, 16))).length() < 1.0:
			continue
		placed.append(spawn(key, p))
		if block:
			_spacing.add(p)
	return placed


## A random world rolls its own trees, rocks, lights and first animals.
func _scatter_random(rng: RandomNumberGenerator) -> void:
	var west: float = params.west
	var east: float = params.east
	var jungle := Rect2(20, 300, west - 60, JH - 300)
	var plateau := Rect2(20, 20, Biomes.CLIFF_END - 40, 300)
	var steppe := Rect2(west + 60, 40, east - west - 100, JH - 60)
	params.trees = _points(rng, 22, jungle, Biomes.JUNGLE, 60.0, true) + _points(rng, 14, plateau, Biomes.JUNGLE, 60.0, true)
	params.rocks = _points(rng, 15, jungle, Biomes.JUNGLE, 50.0, true) + _points(rng, 3, plateau, Biomes.JUNGLE, 50.0, true)
	params.mushrooms = _points(rng, 6, jungle, Biomes.JUNGLE, 60.0, false)
	params.dead_trees = _points(rng, 8, steppe, Biomes.PLAIN, 60.0, true)
	params.boulders = _points(rng, 11, steppe, Biomes.PLAIN, 40.0, true)
	params.lizards = _points(rng, 6, jungle, Biomes.JUNGLE, 40.0, false)
	params.predators = [_points(rng, 1, jungle, Biomes.JUNGLE, 40.0, false)[0], _points(rng, 1, steppe, Biomes.PLAIN, 40.0, false)[0]]
	params.beams = _points(rng, 5, jungle, Biomes.JUNGLE, 100.0, false)
	params.steppe_moons = _points(rng, 4, steppe, Biomes.PLAIN, 200.0, false)
	params.snow_lights = _points(rng, 4, Rect2(east + 40, params.ridge + 60, W - east - 80, H - params.ridge - 100), Biomes.SNOW, 150.0, false)
	params.ash_glows = _points(rng, 2, Rect2(east + 40, 60, W - east - 80, params.ridge - 120), Biomes.VOLCANO, 200.0, false)
	params.glints = [rng.randf_range(200, west - 200), rng.randf_range(west - 100, west + 200), rng.randf_range(west + 300, east - 100)]


## Random free spots in one biome; trees and rocks come back as (x, y, variant).
func _points(rng: RandomNumberGenerator, count: int, area: Rect2, biome: int, spacing: float, variant: bool) -> Array:
	var found := []
	var local := Spacing.new()
	for i in count * 60:
		if found.size() >= count:
			break
		var p := area.position + area.size * Vector2(rng.randf(), rng.randf())
		if Biomes.at(p) != biome or near_water(p) or in_cliff(p, 24.0) or near_path(p, 22.0) or not local.is_free(p, spacing):
			continue
		if p.distance_to(Vector2(params.cave_x, Biomes.bottom(params.cave_x))) < 90.0 or ((p - params.pond) / (POND_R + Vector2(20, 20))).length() < 1.0:
			continue
		if p.distance_to(params.skeleton) < 70.0:
			continue
		local.add(p)
		found.append(Vector3(p.x, p.y, rng.randi() % 2) if variant else p)
	return found


func _lore_spots(rng: RandomNumberGenerator) -> Dictionary:
	var west: float = params.west
	var east: float = params.east
	var spots := {
		"bones": _points(rng, 1, Rect2(40, 360, west - 100, 560), Biomes.JUNGLE, 10.0, false),
		"claws": _points(rng, 1, Rect2(40, 60, Biomes.CLIFF_END - 80, 200), Biomes.JUNGLE, 10.0, false),
		"stones": _points(rng, 1, Rect2(west + 40, 1080, east - west - 80, 420), Biomes.RIVER, 10.0, false),
		"tracks": _points(rng, 1, Rect2(40, 1100, west - 80, 400), Biomes.SWAMP, 10.0, false),
		"glass": _points(rng, 1, Rect2(east + 40, 60, W - east - 80, params.ridge - 100), Biomes.VOLCANO, 10.0, false),
		"ice": _points(rng, 1, Rect2(east + 40, params.ridge + 60, W - east - 80, H - params.ridge - 100), Biomes.SNOW, 10.0, false),
	}
	var lore := {"giant": params.skeleton + Vector2(0, 32)}
	for id: String in spots:
		if not spots[id].is_empty():
			lore[id] = spots[id][0]
	return lore


## Falling leaves, fireflies, steppe wind, ash, embers, snowfall, swamp mist and the lights of every region.
func _fill_the_air() -> void:
	var air: Node2D = main.get_node("Atmosphere")
	var west: float = params.west
	var east := Biomes.EAST
	var ridge := Biomes.RIDGE
	var leaves := _particles(air, "FallingLeaves", Vector2(west / 2.0, JH / 2.0), Vector2(west / 2.0, JH / 2.0), 30, 10.0, Vector2(0.3, 1), Vector2(3, 8),
		Color.WHITE, _fade([Color(1, 1, 1, 0), Color(1, 1, 1, 1), Color(1, 1, 1, 1), Color(1, 1, 1, 0)], [0.0, 0.1, 0.85, 1.0]))
	leaves.texture = load("res://assets/leaf.png")
	leaves.spread = 25.0
	leaves.gravity = Vector2(3, 5)
	leaves.angle_max = 360.0
	leaves.angular_velocity_min = -70.0
	leaves.angular_velocity_max = 70.0
	leaves.color_initial_ramp = _fade([Color(0.25, 0.4, 0.2), Color(0.45, 0.32, 0.16), Color(0.36, 0.2, 0.12)], [0.0, 0.5, 1.0])
	var wind := _particles(air, "SteppeWind", Vector2((west + east) / 2.0, JH / 2.0), Vector2((east - west) / 2.0, JH / 2.0), 50, 6.0, Vector2(1, 0.15), Vector2(18, 40),
		Color(0.85, 0.78, 0.55), _fade([Color(1, 1, 1, 0), Color(1, 1, 1, 0.5), Color(1, 1, 1, 0)], [0.0, 0.5, 1.0]))
	wind.spread = 10.0
	var fire_x := (east + W) / 2.0
	_particles(air, "Ash", Vector2(fire_x, ridge / 2.0), Vector2((W - east) / 2.0, ridge / 2.0), 70, 8.0, Vector2(0.3, 1), Vector2(6, 14),
		Color(0.45, 0.42, 0.42), _fade([Color(1, 1, 1, 0), Color(1, 1, 1, 0.8), Color(1, 1, 1, 0)], [0.0, 0.3, 1.0]))
	_particles(air, "Embers", Vector2(fire_x, ridge / 2.0), Vector2((W - east) / 2.0, ridge / 2.0), 40, 3.0, Vector2(0.2, -1), Vector2(8, 20),
		Color(1, 0.5, 0.15), _fade([Color(1, 1, 1, 0), Color(1, 1, 1, 1), Color(1, 1, 1, 0)], [0.0, 0.2, 1.0])).material = _glow()
	var snowfall := _particles(air, "Snowfall", Vector2(fire_x, (ridge + H) / 2.0), Vector2((W - east) / 2.0, (H - ridge) / 2.0), 110, 7.0, Vector2(-0.3, 1),
		Vector2(8, 18), Color(0.9, 0.94, 1.0), _fade([Color(1, 1, 1, 0), Color(1, 1, 1, 0.9), Color(1, 1, 1, 0)], [0.0, 0.2, 1.0]))
	snowfall.scale_amount_max = 2.0 * Art.SCALE
	var mist := _particles(air, "SwampMist", Vector2(west / 2.0, 1300), Vector2(west / 2.0, 220), 26, 9.0, Vector2(1, -0.1), Vector2(3, 7),
		Color(0.55, 0.65, 0.5), _fade([Color(1, 1, 1, 0), Color(1, 1, 1, 0.35), Color(1, 1, 1, 0)], [0.0, 0.5, 1.0]))
	mist.texture = load("res://assets/smoke.png")
	mist.scale_amount_min = 2.0 * Art.SCALE
	mist.scale_amount_max = 3.5 * Art.SCALE
	for i in params.beams.size():
		var beam := _light(air, "Moonbeam%d" % (i + 1), params.beams[i], Color(0.55, 0.7, 1.0), 0.8, 1.0)
		beam.scale = Vector2(0.4, 2.4)
		beam.rotation = -0.35
	var pond_x: float = params.pond.x
	_light(air, "PondGlow", params.pond, Color(0.35, 0.8, 0.9), 0.25, 1.4)
	_light(air, "FallsGlow", Vector2(pond_x, Biomes.edge(pond_x) + 60.0), Color(0.6, 0.9, 1.0), 0.2, 0.8)
	for i in params.steppe_moons.size(): # the open steppe lies under the bare sky: pale cold moonlight
		_light(air, "SteppeMoon%d" % (i + 1), params.steppe_moons[i], Color(0.62, 0.7, 0.95), 0.4, 5.0)
	for i in params.snow_lights.size():
		_light(air, "SnowLight%d" % (i + 1), params.snow_lights[i], Color(0.7, 0.82, 1.0), 0.45, 5.0)
	for i in params.ash_glows.size():
		_light(air, "AshGlow%d" % (i + 1), params.ash_glows[i], Color(1.0, 0.35, 0.15), 0.3, 4.0)
	for i in params.glints.size():
		var gx: float = params.glints[i]
		_light(air, "RiverGlint%d" % (i + 1), Vector2(gx, Biomes.river_y(gx)), Color(0.45, 0.75, 0.9), 0.3, 3.0)


func _set_up_systems() -> void:
	var west: float = params.west
	var east := Biomes.EAST
	var ridge := Biomes.RIDGE
	(main.get_node("Fog").material as ShaderMaterial).set_shader_parameter("clear_x", Vector2(west - 50.0, west + 150.0))
	main.get_node("Fireflies").area = Rect2(0, 0, west, H)
	var areas := {
		"LizardSpawner": Rect2(40, 360, east - 80, 540), "CompySpawner": Rect2(40, 360, east - 80, 540),
		"ProtoSpawner": Rect2(west + 150, 300, east - west - 250, 620), "RaptorSpawner": Rect2(60, 400, west - 200, 520),
		"DiploSpawner": Rect2(40, 1120, west - 120, 380), "AnkyloSpawner": Rect2(east + 60, 80, W - east - 120, ridge - 160),
		"SnowrunnerSpawner": Rect2(east + 60, ridge + 60, W - east - 120, H - ridge - 120),
	}
	for spawner: String in areas:
		main.get_node(spawner).area = areas[spawner]


func _particles(parent: Node, what: String, center: Vector2, extents: Vector2, amount: int, lifetime: float, dir: Vector2, speed: Vector2,
		color: Color, ramp: Gradient) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.name = what
	p.position = center
	p.amount = amount
	p.lifetime = lifetime
	p.preprocess = lifetime
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = extents
	p.direction = dir
	p.spread = 20.0
	p.gravity = Vector2.ZERO
	p.initial_velocity_min = speed.x
	p.initial_velocity_max = speed.y
	p.scale_amount_min = Art.SCALE # HD: half-size leaves, flakes and embers
	p.scale_amount_max = Art.SCALE
	p.color = color
	p.color_ramp = ramp
	parent.add_child(p)
	return p


func _light(parent: Node, what: String, pos: Vector2, color: Color, energy: float, scale_: float) -> PointLight2D:
	var l := PointLight2D.new()
	l.name = what
	l.position = pos
	l.color = color
	l.energy = energy
	l.texture = load("res://world/light_radial.tres")
	l.texture_scale = scale_
	parent.add_child(l)
	return l


func _fade(colors: Array, offsets: Array) -> Gradient:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array(offsets)
	g.colors = PackedColorArray(colors)
	return g


func _glow() -> CanvasItemMaterial:
	var m := CanvasItemMaterial.new()
	m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	m.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	return m


## The map picture for the automap: each region's colour, the cliff, water and paths, one pixel per cell.
func map_image(cell: int) -> Image:
	var size := Vector2i(int(W) / cell, int(H) / cell)
	var image := Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	var colors := {Biomes.JUNGLE: Color("2d4430"), Biomes.PLAIN: Color("58502f"), Biomes.RIVER: Color("2c4834"), Biomes.SWAMP: Color("282a18"),
		Biomes.VOLCANO: Color("2a2523"), Biomes.SNOW: Color("a0abbe")}
	var water := Color(0.16, 0.34, 0.42)
	var ramp: Vector2 = params.ramp
	for y in size.y:
		for x in size.x:
			var p := (Vector2(x, y) + Vector2(0.5, 0.5)) * cell
			var c: Color = colors[Biomes.at(p)]
			if p.x < Biomes.CLIFF_END and p.y < Biomes.edge(p.x):
				c = c.lightened(0.1)
			elif in_cliff(p, 0.0) and (p.x < ramp.x or p.x > ramp.y):
				c = Color("3b414a")
			if absf(p.y - Biomes.river_y(p.x)) < Biomes.river_half(p.x):
				c = water if p.x < Biomes.EAST else Color("7aa0b5")
			if ((p - params.pond) / POND_R).length() < 1.0:
				c = water
			image.set_pixel(x, y, c)
	for line: Array in params.paths.values() + [params.creek]:
		var color := water if line == params.creek else Color("5a4c3c")
		for i in line.size() - 1:
			var a: Vector2 = line[i] / cell
			var b: Vector2 = line[i + 1] / cell
			for k in ceili(a.distance_to(b) * 2.0) + 1:
				var q := Vector2i(a.lerp(b, k / maxf(ceilf(a.distance_to(b) * 2.0), 1.0)).floor())
				if q.x >= 0 and q.y >= 0 and q.x < size.x and q.y < size.y:
					image.set_pixelv(q, color)
	return image
