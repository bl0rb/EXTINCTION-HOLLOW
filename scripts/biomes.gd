class_name Biomes
## The world's regions (GAME_SPEC §27-§29, §114): where a point lies decides its climate, footing and wildlife.
## Jungle and steppe fill the valley below the cliff, a river runs below them from the snowfields to the swamp,
## the volcano rules the north-east and the snowfields the south-east.
## Where exactly the borders, the river and the cliff run is rolled anew for every age (see World);
## the defaults are the classic world.

enum { JUNGLE, RIVER, SWAMP, PLAIN, VOLCANO, SNOW, DUNGEON }

const NAMES := ["JUNGLE", "RIVER", "SWAMP", "STEPPE", "VOLCANO", "SNOW", "DUNGEON"]
const DUNGEON_Y := 2400.0 ## dungeons lie below the world, out of sight
const BANK := 14.0 ## river banks beyond the water still count as river land
const FORD_HALF := 26.0
const TEMPERATURE := [0.0, -2.0, 2.0, -6.0, 8.0, -30.0, -8.0] ## offset to the weather's temperature
const FOOTING := [1.0, 1.0, 0.6, 1.0, 1.0, 0.85, 1.0] ## mud and deep snow slow the dino down

static var WEST := 1300.0 ## jungle and swamp end here
static var EAST := 2304.0 ## volcano and snowfields start here
static var RIDGE := 820.0 ## the rocky ridge between volcano and snowfields
static var FORDS := [600.0, 1760.0] ## shallow crossings of the river
static var CLIFF_END := 1330.0 ## the cliff runs out into a slope here
static var RAMP := Vector2(1008, 1112) ## the way up the cliff
static var river := [1010.0, 28.0, 170.0, 0.0, 12.0, 61.0, 1.3] ## base, two waves of amplitude, length and phase
static var edge_wave := [250.0, 6.0, 53.0, 0.0, 4.0, 17.0, 1.0] ## the plateau edge, the same way


static func configure(params: Dictionary) -> void:
	WEST = params.west
	EAST = params.east
	RIDGE = params.ridge
	FORDS = params.fords
	CLIFF_END = params.cliff_end
	RAMP = params.ramp
	river = params.river
	edge_wave = params.edge


static func river_y(x: float) -> float:
	return river[0] + river[1] * sin(x / river[2] + river[3]) + river[4] * sin(x / river[5] + river[6])


## Half the river's width: it spreads out into a broad stream in the middle.
static func river_half(x: float) -> float:
	return 20.0 + 10.0 * clampf((x - WEST + 100.0) / 200.0, 0.0, 1.0) * clampf((EAST - 54.0 - x) / 150.0, 0.0, 1.0)


## Top of the cliff: the plateau lies above it.
static func edge(x: float) -> float:
	return edge_wave[0] + edge_wave[1] * sin(x / edge_wave[2] + edge_wave[3]) + edge_wave[4] * sin(x / edge_wave[5] + edge_wave[6])


## Foot of the cliff; towards its end the cliff tapers into a slope.
static func bottom(x: float) -> float:
	return edge(x) + (68.0 + 3.0 * sin(x / 29.0 + 2.0)) * clampf((CLIFF_END - x) / 90.0, 0.0, 1.0)


static func at(pos: Vector2) -> int:
	if pos.y >= DUNGEON_Y:
		return DUNGEON
	if pos.x >= EAST:
		return VOLCANO if pos.y < RIDGE else SNOW
	var river_at := river_y(pos.x)
	if absf(pos.y - river_at) < river_half(pos.x) + BANK:
		return RIVER
	if pos.y > river_at:
		return SWAMP if pos.x < WEST else RIVER
	return JUNGLE if pos.x < WEST else PLAIN


static func name_at(pos: Vector2) -> String:
	return NAMES[at(pos)]
