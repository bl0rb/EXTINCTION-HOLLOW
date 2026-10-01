class_name Loot
## Items (GAME_SPEC §150): trophies the dino wears as mutations - teeth, claws, hide and amber - in four rarities.
## Bigger animals drop more often and better items. Set pieces make builds: worn together they grant extra power.

const SLOTS := ["teeth", "claws", "hide", "amber"]
const SLOT_NAMES := {"teeth": "Teeth", "claws": "Claws", "hide": "Hide", "amber": "Amber"}
const RARITY_NAMES := ["Common", "Magic", "Rare", "Legendary", "Set"]
const COLORS := [Color(0.8, 0.78, 0.72), Color(0.45, 0.62, 1.0), Color(1.0, 0.86, 0.3), Color(1.0, 0.52, 0.12), Color(0.3, 0.95, 0.72)]
const VALUE := [2, 5, 12, 30, 20] ## XP for salvaging an item
const SET := 4 ## the rarity of set pieces
## Builds: four pieces each, one per slot. Two worn pieces add stats, all four a special power.
const SETS := {
	"tyrant": {"name": "Tyrant's Might", "prefix": "Tyrant's", "two": {"damage": 4, "health": 20}, "power": "kills heal 15% health"},
	"raptor": {"name": "Raptor's Cunning", "prefix": "Raptor's", "two": {"crit": 6, "attack_speed": 12}, "power": "crits bite 3x as hard"},
	"ankylo": {"name": "Ankylo's Bulwark", "prefix": "Ankylo's", "two": {"armor": 8, "health": 25}, "power": "biters take half back"},
	"elder": {"name": "Elder's Wisdom", "prefix": "Elder's", "two": {"xp": 15, "speed": 8}, "power": "skills faster, cheaper"},
}
const SET_COLORS := { ## the crest glows in the colour of the build worn
	"tyrant": Color(1.0, 0.32, 0.26), "raptor": Color(1.0, 0.8, 0.3), "ankylo": Color(0.62, 0.76, 1.0), "elder": Color(0.4, 1.0, 0.78),
}
const SET_CHANCE := 0.04 ## share of ordinary drops that are set pieces
const ELITE_SET_CHANCE := 0.3 ## share of an elite's or boss's extra drops
const BETTER := Color(0.45, 0.92, 0.4) ## an item beats what is worn
const WORSE := Color(1.0, 0.35, 0.3)
const BASES := {
	"teeth": ["Tooth", "Fang", "Sabre Tooth"],
	"claws": ["Claw", "Talon", "Sickle Claw"],
	"hide": ["Hide", "Scales", "Plated Hide"],
	"amber": ["Amber", "Amber Shard", "Amber Heart"],
}
const MAIN := {"teeth": "damage", "claws": "crit", "hide": "health", "amber": "xp"} ## every slot's own stat
const STATS := { ## roll range at item level 1
	"damage": [2.0, 4.0], "crit": [2.0, 4.0], "attack_speed": [4.0, 8.0], "health": [8.0, 16.0],
	"armor": [2.0, 5.0], "speed": [3.0, 6.0], "life_hit": [1.0, 2.0], "xp": [5.0, 10.0],
}
const STAT_TEXT := {
	"damage": "+%d damage", "crit": "+%d%% critical hits", "attack_speed": "+%d%% bite speed", "health": "+%d health",
	"armor": "+%d%% armour", "speed": "+%d speed", "life_hit": "+%d life per hit", "xp": "+%d%% XP",
}
const PREFIX := {
	"damage": "Savage", "crit": "Keen", "attack_speed": "Swift", "health": "Hardy",
	"armor": "Plated", "speed": "Fleet", "life_hit": "Hungry", "xp": "Wise",
}
const DROP_CHANCE := [0.0, 0.12, 0.35, 0.6, 1.0, 1.0] ## by size class
const DROP := "res://scenes/loot_drop.tscn" ## loaded when needed: the drop scene refers back to this class


## A random item; the level (1-5) scales its stats and base, rarity -1 rolls one (but at least min_rarity).
static func roll(level: int, rarity := -1, min_rarity := 0) -> Dictionary:
	if rarity < 0:
		var r := randf()
		rarity = maxi(3 if r < 0.03 else (2 if r < 0.13 else (1 if r < 0.4 else 0)), min_rarity)
	var slot: String = SLOTS[randi() % SLOTS.size()]
	var main: String = MAIN[slot]
	var power := (1.0 + 0.5 * (level - 1)) * (1.3 if rarity == 3 else 1.0)
	var stats := {main: _roll_stat(main, power)}
	var pool: Array = STATS.keys().filter(func(s: String) -> bool: return s != main)
	pool.shuffle()
	for i in [0, 1, 2 + randi() % 2, 3][rarity]:
		stats[pool[i]] = _roll_stat(pool[i], power)
	var base: String = BASES[slot][mini(level - 1, 2)]
	var title := base
	if rarity == 3:
		title = "Ancient " + base
	elif rarity > 0:
		title = "%s %s" % [PREFIX[pool[0]], base]
	return {"slot": slot, "rarity": rarity, "name": title, "level": level, "stats": stats}


## A piece of a set (random set and slot unless given): its slot's own stat, one more, and the set's name.
static func roll_set(level: int, set_id := "", slot := "") -> Dictionary:
	if set_id == "":
		set_id = SETS.keys().pick_random()
	if slot == "":
		slot = SLOTS.pick_random()
	var main: String = MAIN[slot]
	var power := (1.0 + 0.5 * (level - 1)) * 1.15
	var stats := {main: _roll_stat(main, power)}
	var other: String = STATS.keys().filter(func(s: String) -> bool: return s != main).pick_random()
	stats[other] = _roll_stat(other, power)
	var title := "%s %s" % [SETS[set_id].prefix, BASES[slot][mini(level - 1, 2)]]
	return {"slot": slot, "rarity": SET, "name": title, "level": level, "stats": stats, "set": set_id}


## An item's name in the language in use, built from its parts: the stored name stays English (GAME_SPEC §157).
static func item_name(item: Dictionary) -> String:
	var base := TranslationServer.translate(BASES[item.slot][mini(item.level - 1, 2)])
	if item.get("set", "") != "":
		return TranslationServer.translate(SETS[item.set].prefix + " %s") % base
	if item.rarity == 3:
		return TranslationServer.translate("Ancient %s") % base
	if item.rarity > 0 and item.stats.size() > 1:
		return TranslationServer.translate(PREFIX[item.stats.keys()[1]] + " %s") % base
	return base


static func _roll_stat(id: String, power: float) -> int:
	return maxi(1, roundi(randf_range(STATS[id][0], STATS[id][1]) * power))


## Sum of all stats of the worn items, with the bonus of every set worn twice or more.
static func total(equipped: Dictionary) -> Dictionary:
	var sum := {}
	for slot: String in equipped:
		var stats: Dictionary = equipped[slot].get("stats", {})
		for id: String in stats:
			sum[id] = sum.get(id, 0.0) + stats[id]
	var counts := set_counts(equipped)
	for set_id: String in counts:
		if counts[set_id] >= 2:
			for id: String in SETS[set_id].two:
				sum[id] = sum.get(id, 0.0) + SETS[set_id].two[id]
	return sum


## How many pieces of each set are worn: set id -> count.
static func set_counts(equipped: Dictionary) -> Dictionary:
	var counts := {}
	for slot: String in equipped:
		var set_id: String = equipped[slot].get("set", "")
		if set_id != "":
			counts[set_id] = counts.get(set_id, 0) + 1
	return counts


## The sets whose special power is active: all four pieces worn.
static func set_powers(equipped: Dictionary) -> Array:
	var counts := set_counts(equipped)
	return counts.keys().filter(func(set_id: String) -> bool: return counts[set_id] >= 4)


## Lines about an item's set for tooltips: [text, active] pairs.
static func describe_set(item: Dictionary, equipped: Dictionary) -> Array:
	var set_id: String = item.get("set", "")
	if set_id == "":
		return []
	var info: Dictionary = SETS[set_id]
	var count: int = set_counts(equipped).get(set_id, 0)
	var lines := [["%s %d/4" % [TranslationServer.translate(info.name), count], true]]
	var prefix := "2: "
	for id: String in info.two:
		lines.append([prefix + TranslationServer.translate(STAT_TEXT[id]) % info.two[id], count >= 2])
		prefix = "   "
	lines.append(["4: " + TranslationServer.translate(info.power), count >= 4])
	return lines


## How wearing an item would change the dino's stats against what it wears in that slot: stat id -> difference.
static func compare(item: Dictionary, worn: Dictionary) -> Dictionary:
	var diff := {}
	var old: Dictionary = worn.get("stats", {})
	for id: String in item.stats:
		diff[id] = int(item.stats[id] - old.get(id, 0))
	for id: String in old:
		if not item.stats.has(id):
			diff[id] = -int(old[id])
	return diff


## 1 if an item is better than what is worn in its slot, -1 if worse, 0 if about the same.
## Every stat counts in proportion to its roll range, so +3 damage weighs like +3% crit but more than +3 health.
static func verdict(item: Dictionary, worn: Dictionary) -> int:
	if worn.is_empty():
		return 1
	var score := 0.0
	var diff := compare(item, worn)
	for id: String in diff:
		score += diff[id] / STATS[id][1]
	return 0 if absf(score) < 0.25 else (1 if score > 0.0 else -1)


## One stat change as text, e.g. "+3 damage" or "-2% armour".
static func change_text(id: String, amount: int) -> String:
	return ("-" if amount < 0 else "+") + (TranslationServer.translate(STAT_TEXT[id]) % absi(amount)).substr(1)


## A small pixel arrow: green and up for a better item, red and down for a worse one, nothing for about the same.
static func draw_arrow(canvas: CanvasItem, at: Vector2, direction: int) -> void:
	if direction == 0:
		return
	var p := at.round()
	for row in 3:
		var y := row if direction > 0 else 2 - row
		canvas.draw_rect(Rect2(p + Vector2(-row - 1, y), Vector2(3 + 2 * row, 2)), Color(0.02, 0.02, 0.03, 0.8))
	for row in 3:
		var y := row if direction > 0 else 2 - row
		canvas.draw_rect(Rect2(p + Vector2(-row, y), Vector2(1 + 2 * row, 1)), Loot.BETTER if direction > 0 else Loot.WORSE)


static func describe(item: Dictionary) -> PackedStringArray:
	var lines := PackedStringArray()
	for id: String in item.stats:
		lines.append(TranslationServer.translate(STAT_TEXT[id]) % item.stats[id])
	return lines


## A killed animal may leave an item behind; the bigger it was, the likelier and better.
## Elites and bosses always drop extra items of a guaranteed rarity.
static func drop(parent: Node, pos: Vector2, size: int, extra := 0, min_rarity := 0) -> void:
	var drops := 1 if randf() < DROP_CHANCE[clampi(size, 0, 5)] else 0
	if size >= 4 and randf() < 0.5:
		drops += 1
	var level := clampi(size, 1, 5)
	for i in drops + extra:
		var set_piece := randf() < (ELITE_SET_CHANCE if i >= drops else SET_CHANCE)
		spawn(parent, pos + Vector2(randf_range(-14, 14), randf_range(-8, 8)), roll_set(level) if set_piece else roll(level, -1, min_rarity))
	if extra >= 3: # a boss always leaves a set piece
		spawn(parent, pos + Vector2(randf_range(-14, 14), randf_range(-8, 8)), roll_set(level))


static func spawn(parent: Node, pos: Vector2, item: Dictionary) -> Node2D:
	var node: Node2D = load(DROP).instantiate()
	node.item = item
	node.position = pos
	parent.add_child(node)
	return node
