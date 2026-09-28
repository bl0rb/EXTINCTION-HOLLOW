class_name SaveGame
## Progress is saved when the player is in the cave (GAME_SPEC §55).

const PATH := "user://savegame.cfg"


static func read(section: String, key: String, default: Variant) -> Variant:
	var file := ConfigFile.new()
	if file.load(PATH) != OK:
		return default
	return file.get_value(section, key, default)


static func store(player: Player, cave: Cave) -> void:
	var file := ConfigFile.new()
	file.set_value("player", "banked_xp", player.banked_xp)
	file.set_value("player", "upgrades", player.upgrades)
	file.set_value("player", "total_xp", player.total_xp)
	file.set_value("player", "talents", player.talents)
	file.set_value("player", "bag", player.bag)
	file.set_value("player", "equipped", player.equipped)
	file.set_value("cave", "levels", cave.levels)
	var story := player.get_tree().get_first_node_in_group("story") as Story
	if story:
		file.set_value("story", "time", story.time)
		file.set_value("story", "found", story.found)
	var hud := player.get_tree().get_first_node_in_group("hud")
	if hud:
		file.set_value("map", "explored", hud.automap.explored.get_data())
	file.save(PATH)
