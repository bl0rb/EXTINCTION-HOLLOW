class_name Sound
## Sound (GAME_SPEC §54, T094-T099): generated sounds from assets/audio, played once at a place in the world
## or looped and faded in and out with what is going on.

const PATH := "res://assets/audio/%s.wav"
const HEARING := 520.0 ## one-shots fade out over this distance from the middle of the view


## Plays a sound once at a place in the world, a little differently each time.
static func play(parent: Node, sound: String, at: Vector2, volume_db := 0.0, pitch := 1.0, reach := HEARING) -> void:
	var player := AudioStreamPlayer2D.new()
	player.stream = load(PATH % sound)
	player.volume_db = volume_db
	player.pitch_scale = pitch * randf_range(0.92, 1.08)
	player.max_distance = reach
	player.bus = &"Effects"
	parent.add_child(player)
	player.global_position = at
	player.play()
	parent.get_tree().create_timer(player.stream.get_length() / player.pitch_scale + 0.1).timeout.connect(player.queue_free)


## A looping sound that starts silent; fade() brings it in. Pass a 2D player to hear it from a place in the world.
static func loop(parent: Node, sound: String, player: Node = null) -> Node:
	var stream: AudioStreamWAV = load(PATH % sound)
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = int(stream.get_length() * stream.mix_rate)
	if player == null:
		player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = &"Ambience"
	player.volume_linear = 0.0
	player.autoplay = true
	player.stream_paused = true
	parent.add_child(player)
	return player


## Moves a loop's volume towards a level (0..1) and pauses it while it cannot be heard.
static func fade(player: Node, level: float, delta: float, rate := 0.5) -> void:
	player.volume_linear = move_toward(player.volume_linear, level, delta * rate)
	player.stream_paused = player.volume_linear < 0.001
