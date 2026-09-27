extends Node2D
## Keeps an animal population alive by spawning new ones out of the player's sight.

@export var scene: PackedScene
@export var group := "" ## animals of this group are counted
@export var count := 6
@export var group_size := 1 ## herds and packs spawn together
@export var interval := 6.0 ## seconds between spawn attempts
@export var area := Rect2() ## where to spawn on land (ignored when spawning into a pond)
@export var min_player_distance := 320.0
@export var spawn_parent: NodePath

var _time := 0.0
var _filled := false

@onready var _parent: Node2D = get_node(spawn_parent)
@onready var _player: Node2D = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	if _parent is Pond:
		# fish can be spawned right away, the pond is not reachable for the player
		for i in count - get_tree().get_nodes_in_group(group).size():
			_spawn(_parent.random_point())


func _physics_process(delta: float) -> void:
	# the world starts populated, then losses are replaced out of sight
	_time += delta
	if _filled and _time < interval:
		return
	_time = 0.0
	var groups := 1 if _filled else ceili(float(count) / group_size)
	_filled = true
	for g in groups:
		var missing := count - get_tree().get_nodes_in_group(group).size()
		if missing <= 0:
			return
		for attempt in 10:
			var point: Vector2 = _parent.random_point() if _parent is Pond else area.position + area.size * Vector2(randf(), randf())
			if point.distance_to(_player.global_position) >= min_player_distance and _is_free(point):
				_spawn(point)
				for i in mini(group_size, missing) - 1:
					var buddy := point + Vector2(randf_range(-28, 28), randf_range(-18, 18))
					if _is_free(buddy):
						_spawn(buddy)
				break


func _is_free(point: Vector2) -> bool:
	if _parent is Pond:
		return true
	var query := PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collision_mask = 1
	return get_world_2d().direct_space_state.intersect_point(query, 1).is_empty()


func _spawn(point: Vector2) -> void:
	var animal: Node2D = scene.instantiate()
	animal.position = point - _parent.global_position if _parent is Pond else point
	_parent.add_child(animal)
