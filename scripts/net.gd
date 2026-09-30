class_name Net
extends Node
## LAN multiplayer (GAME_SPEC §155): up to eight dinos in one world. One player hosts, the others join by IP.
## The game talks to Net through static functions. A single instance at /root/NetHub (an autoload, or made on demand)
## carries the connection; since it has the same path on every machine, every message crosses the network through it:
## reliable messages for events, a stream for positions that may drop a packet now and then.

signal roster_changed
signal status(text: String)
signal message(sender: int, kind: String, args: Array)

const PORT := 7777
const MAX_PLAYERS := 8
const LOBBY := "res://scenes/lobby.tscn"
const GAME := "res://scenes/main.tscn"
const TITLE := "res://scenes/title.tscn"
const MODES := ["versus", "survival"]
const PVP_DAMAGE := 0.6 ## bites between dinos hurt less, so fights last

static var active := false ## a session is open (hosting or joined)
static var in_game := false
static var mode := "survival"
static var world_seed := 0
static var players := {} ## peer id -> {name, color, level}
static var profile := {} ## our own entry, from the save we bring


## The node that carries the connection.
static func hub() -> Net:
	var tree := Engine.get_main_loop() as SceneTree
	var node := tree.root.get_node_or_null("NetHub") as Net
	if node == null:
		node = Net.new()
		node.name = "NetHub"
		tree.root.add_child(node)
	return node


static func is_host() -> bool:
	return active and hub().multiplayer.is_server()


static func my_id() -> int:
	return hub().multiplayer.get_unique_id() if active else 1


## Our entry in the roster, from the chosen save slot.
static func load_profile() -> void:
	var info := SaveGame.summary(SaveGame.slot)
	profile = {"name": info.get("name", "Dino"), "color": info.get("color", 0), "level": info.get("level", 1)}


static func host(port := PORT) -> Error:
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_server(port, MAX_PLAYERS - 1)
	if err != OK:
		hub().status.emit("port %d is busy" % port)
		return err
	hub()._open(peer)
	players = {1: profile}
	hub().roster_changed.emit()
	hub().status.emit("hosting on port %d" % port)
	return OK


static func join(address: String, port := PORT) -> Error:
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(address, port)
	if err != OK:
		hub().status.emit("cannot reach %s" % address)
		return err
	hub()._open(peer)
	hub().status.emit("connecting to %s ..." % address)
	return OK


## Closes the session and goes back to the start screen.
static func leave() -> void:
	hub()._close()
	var tree := Engine.get_main_loop() as SceneTree
	tree.paused = false
	tree.change_scene_to_file(TITLE)


static func set_mode(new_mode: String) -> void:
	if is_host():
		hub()._mode.rpc(new_mode)


## The host starts a round: everyone builds the same world from the same seed.
static func start_game() -> void:
	if is_host():
		hub()._start.rpc(randi_range(1, 999999), mode)


## Everyone back to the lobby, e.g. after a round.
static func back_to_lobby() -> void:
	if is_host():
		hub()._lobby.rpc()


## A message to everyone else (to = 0) or to one peer; streams may drop packets and are for positions.
static func send(kind: String, args := [], to := 0, stream := false) -> void:
	if not active:
		return
	var node := hub()
	if to == my_id():
		node.message.emit(to, kind, args)
	elif stream:
		if to == 0:
			node._stream.rpc(kind, args)
		else:
			node._stream.rpc_id(to, kind, args)
	elif to == 0:
		node._msg.rpc(kind, args)
	else:
		node._msg.rpc_id(to, kind, args)


## This machine's addresses in the local network, for the lobby.
static func local_addresses() -> PackedStringArray:
	var found := PackedStringArray()
	for address in IP.get_local_addresses():
		if address.count(".") == 3 and not address.begins_with("127.") and not address.begins_with("169.254"):
			found.append(address)
	return found


func _open(peer: MultiplayerPeer) -> void:
	multiplayer.multiplayer_peer = peer
	active = true
	in_game = false
	if not multiplayer.peer_disconnected.is_connected(_on_peer_disconnected):
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		multiplayer.connected_to_server.connect(_on_connected)
		multiplayer.connection_failed.connect(_on_failed)
		multiplayer.server_disconnected.connect(_on_host_left)


func _close() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	active = false
	in_game = false
	players.clear()


func _on_connected() -> void:
	status.emit("connected")
	_register.rpc_id(1, profile)


func _on_failed() -> void:
	_close()
	status.emit("could not reach the host")


func _on_host_left() -> void:
	leave()


func _on_peer_disconnected(id: int) -> void:
	if players.erase(id) and is_host():
		_roster.rpc(players)
	message.emit(id, "left", [])


@rpc("any_peer", "reliable")
func _register(data: Dictionary) -> void:
	var sender := multiplayer.get_remote_sender_id()
	if players.size() >= MAX_PLAYERS or in_game:
		_rejected.rpc_id(sender, "the game is full" if players.size() >= MAX_PLAYERS else "a round is running")
		return
	players[sender] = data
	_roster.rpc(players)
	_mode.rpc_id(sender, mode)


@rpc("authority", "reliable")
func _rejected(reason: String) -> void:
	_close()
	status.emit(reason)


@rpc("authority", "call_local", "reliable")
func _roster(list: Dictionary) -> void:
	players = list
	roster_changed.emit()


@rpc("authority", "call_local", "reliable")
func _mode(new_mode: String) -> void:
	mode = new_mode
	roster_changed.emit()


@rpc("authority", "call_local", "reliable")
func _start(seed_value: int, new_mode: String) -> void:
	world_seed = seed_value
	mode = new_mode
	in_game = true
	get_tree().paused = false
	get_tree().change_scene_to_file(GAME)


@rpc("authority", "call_local", "reliable")
func _lobby() -> void:
	in_game = false
	get_tree().paused = false
	get_tree().change_scene_to_file(LOBBY)


@rpc("any_peer", "call_remote", "reliable")
func _msg(kind: String, args: Array) -> void:
	message.emit(multiplayer.get_remote_sender_id(), kind, args)


@rpc("any_peer", "call_remote", "unreliable_ordered")
func _stream(kind: String, args: Array) -> void:
	message.emit(multiplayer.get_remote_sender_id(), kind, args)
