extends CharacterBody2D
## Player dino: click-to-move, hunting prey and carrying XP back to the cave.

const SAVE_PATH := "user://savegame.cfg"
const PICK_TOLERANCE := 8.0 ## extra pixels so small animals are easy to click

@export var speed := 90.0 ## pixels per second
@export var turn_speed := 12.0 ## radians per second
@export var bite_range := 18.0 ## reach from the centre in pixels, added to the prey radius

var carried_xp := 0 ## XP collected outside the cave, lost on death
var banked_xp := 0 ## XP brought to the cave, kept permanently

var target := Vector2.ZERO
var moving := false
var prey: Prey

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	var save := ConfigFile.new()
	if save.load(SAVE_PATH) == OK:
		banked_xp = save.get_value("progress", "banked_xp", 0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		click_at(get_global_mouse_position())
		get_viewport().set_input_as_handled()


func click_at(point: Vector2) -> void:
	# a new click always replaces the previous target
	target = point
	# clicking an animal selects it as prey, clicking the ground just walks there
	prey = _prey_at(point)
	var cave := get_tree().get_first_node_in_group("cave") as Cave
	if prey == null and cave and point.distance_to(cave.global_position) <= cave.radius:
		# clicking the cave walks right into its entrance
		target = cave.global_position
	moving = true


func enter_cave() -> void:
	# XP is only safe once it is brought home
	banked_xp += carried_xp
	carried_xp = 0
	var save := ConfigFile.new()
	save.set_value("progress", "banked_xp", banked_xp)
	save.save(SAVE_PATH)


func _physics_process(delta: float) -> void:
	if is_instance_valid(prey):
		# keep chasing the selected prey wherever it runs
		target = prey.global_position
		moving = true
	elif prey != null:
		prey = null
		moving = false
	if not moving:
		return

	var to_target := target - global_position
	sprite.rotation = rotate_toward(sprite.rotation, to_target.angle(), turn_speed * delta)
	var arrived := to_target.length() <= speed * delta
	velocity = to_target / delta if arrived else to_target.normalized() * speed
	var before := global_position
	move_and_slide() # slides along walls
	if arrived or global_position.distance_to(before) < 0.01:
		moving = false

	if prey and global_position.distance_to(prey.global_position) <= bite_range + prey.radius:
		_eat()


func _eat() -> void:
	carried_xp += prey.species.xp
	prey.queue_free()
	prey = null
	moving = false


func _prey_at(point: Vector2) -> Prey:
	var best: Prey = null
	var best_dist := INF
	for animal: Prey in get_tree().get_nodes_in_group("prey"):
		var dist := point.distance_to(animal.global_position)
		if dist <= animal.radius + PICK_TOLERANCE and dist < best_dist:
			best = animal
			best_dist = dist
	return best
