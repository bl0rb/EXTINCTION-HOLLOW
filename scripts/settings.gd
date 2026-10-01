class_name Settings
## Options (GAME_SPEC §156): volume, window, screen shake and language, kept in user://settings.cfg for every save.

const PATH := "user://settings.cfg"
const LANGUAGES := {"de": "DEUTSCH", "en": "ENGLISH"} ## each named in its own words

static var volume := 1.0 ## everything
static var ambience := 1.0 ## rain, the jungle, the volcano, the meteor
static var effects := 1.0 ## bites, roars, impacts
static var fullscreen := true
static var shake := true
static var language := "" ## "" follows the system
static var _loaded := false


## Reads the options once per run and applies them.
static func ensure() -> void:
	if _loaded:
		return
	_loaded = true
	var file := ConfigFile.new()
	if file.load(PATH) == OK:
		volume = file.get_value("audio", "volume", volume)
		ambience = file.get_value("audio", "ambience", ambience)
		effects = file.get_value("audio", "effects", effects)
		fullscreen = file.get_value("display", "fullscreen", fullscreen)
		shake = file.get_value("display", "shake", shake)
		language = file.get_value("display", "language", language)
	apply()


static func save() -> void:
	var file := ConfigFile.new()
	file.set_value("audio", "volume", volume)
	file.set_value("audio", "ambience", ambience)
	file.set_value("audio", "effects", effects)
	file.set_value("display", "fullscreen", fullscreen)
	file.set_value("display", "shake", shake)
	file.set_value("display", "language", language)
	file.save(PATH)
	apply()


static func apply() -> void:
	for bus: Array in [["Master", volume], ["Ambience", ambience], ["Effects", effects]]:
		var index := AudioServer.get_bus_index(bus[0])
		if index >= 0:
			AudioServer.set_bus_volume_db(index, linear_to_db(maxf(bus[1], 0.0001)))
			AudioServer.set_bus_mute(index, bus[1] <= 0.0)
	TranslationServer.set_locale(locale())
	if DisplayServer.get_name() != "headless":
		_apply_window()


## The language in use: the chosen one, else German on a German system and English everywhere else.
static func locale() -> String:
	if language != "":
		return language
	return "de" if OS.get_locale_language() == "de" else "en"


## Fullscreen, or a window as big as fits at a whole multiple of the 640x360 picture, in the middle of the screen.
static func _apply_window() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var area := DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen())
	var times := maxi(1, mini((area.size.x - 64) / 640, (area.size.y - 96) / 360))
	var window_size := Vector2i(640, 360) * times
	DisplayServer.window_set_size(window_size)
	DisplayServer.window_set_position(area.position + (area.size - window_size) / 2)
