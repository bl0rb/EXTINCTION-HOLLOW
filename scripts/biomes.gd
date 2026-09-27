class_name Biomes
## The world's regions (GAME_SPEC §27-§29, §114): where a point lies decides its climate, footing and wildlife.
## Jungle and steppe fill the valley, a river runs below them from the snowfields to the swamp,
## the volcano rules the north-east and the snowfields the south-east.

enum { JUNGLE, RIVER, SWAMP, PLAIN, VOLCANO, SNOW }

const NAMES := ["JUNGLE", "RIVER", "SWAMP", "STEPPE", "VOLCANO", "SNOW"]
const WEST := 1300.0 ## jungle and swamp end here
const EAST := 2304.0 ## volcano and snowfields start here
const RIDGE := 820.0 ## the rocky ridge between volcano and snowfields
const BANK := 14.0 ## river banks beyond the water still count as river land
const FORDS := [600.0, 1760.0] ## shallow crossings
const FORD_HALF := 26.0
const TEMPERATURE := [0.0, -2.0, 2.0, -6.0, 8.0, -30.0] ## offset to the weather's temperature
const FOOTING := [1.0, 1.0, 0.6, 1.0, 1.0, 0.85] ## mud and deep snow slow the dino down


static func river_y(x: float) -> float:
	return 1010.0 + 28.0 * sin(x / 170.0) + 12.0 * sin(x / 61.0 + 1.3)


## Half the river's width: it spreads out into a broad stream in the middle.
static func river_half(x: float) -> float:
	return 20.0 + 10.0 * clampf((x - 1200.0) / 200.0, 0.0, 1.0) * clampf((2250.0 - x) / 150.0, 0.0, 1.0)


static func at(pos: Vector2) -> int:
	if pos.x >= EAST:
		return VOLCANO if pos.y < RIDGE else SNOW
	var river := river_y(pos.x)
	if absf(pos.y - river) < river_half(pos.x) + BANK:
		return RIVER
	if pos.y > river:
		return SWAMP if pos.x < WEST else RIVER
	return JUNGLE if pos.x < WEST else PLAIN


static func name_at(pos: Vector2) -> String:
	return NAMES[at(pos)]
