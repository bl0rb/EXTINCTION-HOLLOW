class_name SaveGame
## Progress is saved when the player is in the cave (GAME_SPEC §55), in one of five slots under user://savegames.
## Each slot keeps its dino's profile (name, primary colour) next to the progress.

const DIR := "user://savegames"
const SLOTS := 5
const LEGACY := "user://savegame.cfg" ## the single save of earlier versions, moved into the first slot

static var slot := 0 ## the slot being played
static var mode := "standard" ## "standard" or "survival" (GAME_SPEC §154)


static func path(index := -1) -> String:
	return "%s/slot_%d.cfg" % [DIR, (slot if index < 0 else index) + 1]


static func exists(index: int) -> bool:
	return FileAccess.file_exists(path(index))


static func read(section: String, key: String, default: Variant) -> Variant:
	var file := ConfigFile.new()
	if file.load(path()) != OK:
		return default
	return file.get_value(section, key, default)


## A new dino in a slot: only its profile, the progress starts from nothing.
static func create(index: int, dino_name: String, color: int) -> void:
	DirAccess.make_dir_recursive_absolute(DIR)
	var file := ConfigFile.new()
	file.set_value("profile", "name", dino_name)
	file.set_value("profile", "color", color)
	file.set_value("profile", "created", Time.get_unix_time_from_system())
	file.set_value("profile", "played", Time.get_unix_time_from_system())
	file.save(path(index))


static func delete(index: int) -> void:
	DirAccess.remove_absolute(path(index))


## What the save menu shows about a slot; empty when the slot is free.
static func summary(index: int) -> Dictionary:
	var file := ConfigFile.new()
	if file.load(path(index)) != OK:
		return {}
	var cave: Dictionary = file.get_value("cave", "levels", {})
	return {
		"name": file.get_value("profile", "name", "Dino"),
		"color": file.get_value("profile", "color", 0),
		"level": Talents.level_for(file.get_value("player", "total_xp", 0)),
		"cave": cave.get("level", 1),
		"phase": Story.phase_at(file.get_value("story", "time", 0.0)),
		"played": file.get_value("profile", "played", 0.0),
		"best": file.get_value("survival", "best", 0),
	}


## Moves the save of earlier versions into the first slot, once.
static func migrate() -> void:
	if not FileAccess.file_exists(LEGACY) or exists(0):
		return
	DirAccess.make_dir_recursive_absolute(DIR)
	var file := ConfigFile.new()
	file.load(LEGACY)
	file.set_value("profile", "name", "Dino")
	file.set_value("profile", "color", 0)
	file.set_value("profile", "played", Time.get_unix_time_from_system())
	if file.save(path(0)) == OK:
		DirAccess.remove_absolute(LEGACY)


## Writes a single value into the current slot.
static func write(section: String, key: String, value: Variant) -> void:
	var file := ConfigFile.new()
	file.load(path())
	file.set_value(section, key, value)
	file.save(path())


static func store(player: Player, cave: Cave) -> void:
	DirAccess.make_dir_recursive_absolute(DIR)
	var file := ConfigFile.new()
	file.load(path()) # keeps what is not written here
	file.set_value("profile", "name", player.dino_name)
	file.set_value("profile", "color", player.color_index)
	file.set_value("profile", "played", Time.get_unix_time_from_system())
	file.set_value("player", "banked_xp", player.banked_xp)
	file.set_value("player", "upgrades", player.upgrades)
	file.set_value("player", "total_xp", player.total_xp)
	file.set_value("player", "talents", player.talents)
	file.set_value("player", "bag", player.bag)
	file.set_value("player", "equipped", player.equipped)
	file.set_value("cave", "levels", cave.levels)
	var world := player.get_tree().get_first_node_in_group("world_map") as World
	if world:
		file.set_value("world", "seed", world.seed_value)
	var story := player.get_tree().get_first_node_in_group("story") as Story
	if story:
		file.set_value("story", "time", story.time)
		file.set_value("story", "found", story.found)
	var hud := player.get_tree().get_first_node_in_group("hud")
	if hud:
		file.set_value("map", "explored", hud.automap.explored.get_data())
	file.save(path())
