class_name Player
extends CharacterBody2D
## Player dino: click-to-move, hunting prey and carrying XP back to the cave.

const SAVE_PATH := "user://savegame.cfg"
const PICK_TOLERANCE := 8.0 ## extra pixels so small animals are easy to click

@export var speed := 90.0 ## pixels per second
@export var bite_range := 18.0 ## reach from the centre in pixels, added to the prey radius
@export var max_health := 100

var carried_xp := 0 ## XP collected outside the cave, lost on death
var banked_xp := 0 ## XP brought to the cave, kept permanently
var health := max_health
var dead := false
var size_level := 2 ## size class (GAME_SPEC §8), the player starts small

var target := Vector2.ZERO
var moving := false
var prey: Animal
var _step := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: GameCamera = $Camera2D


func _ready() -> void:
	health = max_health
	var save := ConfigFile.new()
	if save.load(SAVE_PATH) == OK:
		banked_xp = save.get_value("progress", "banked_xp", 0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		click_at(get_global_mouse_position())
		get_viewport().set_input_as_handled()


func get_size() -> int:
	return size_level


func click_at(point: Vector2) -> void:
	if dead:
		return
	# a new click always replaces the previous target
	target = point
	# clicking an animal small enough to eat selects it as prey, anything else just walks there
	prey = _prey_at(point)
	var cave := get_tree().get_first_node_in_group("cave") as Cave
	if prey == null and cave and cave.is_clicked(point):
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


func take_damage(amount: int) -> void:
	if dead:
		return
	health -= amount
	camera.shake(3.0, 0.25)
	sprite.modulate = Color(1.0, 0.25, 0.2)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.25)
	if health <= 0:
		_die()


func _die() -> void:
	dead = true
	moving = false
	prey = null
	# XP that was not brought home is lost
	carried_xp = 0
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color(0.5, 0.08, 0.06), 0.3)
	tween.parallel().tween_property(sprite, "scale:y", 0.35, 0.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0).set_delay(0.6)
	tween.tween_callback(_respawn)


func _respawn() -> void:
	# the cave is the spawn point
	global_position = (get_tree().get_first_node_in_group("cave") as Cave).global_position
	camera.reset_smoothing()
	health = max_health
	sprite.scale = Vector2.ONE
	sprite.modulate = Color.WHITE
	dead = false


func _physics_process(delta: float) -> void:
	if dead:
		return
	if is_instance_valid(prey):
		# keep chasing the selected prey wherever it runs
		target = prey.global_position
		moving = true
	elif prey != null:
		prey = null
		moving = false
	if not moving:
		velocity = Vector2.ZERO
		sprite.frame = 0
		return

	var to_target := target - global_position
	_animate(to_target, delta)
	var arrived := to_target.length() <= speed * delta
	velocity = to_target / delta if arrived else to_target.normalized() * speed
	var before := global_position
	move_and_slide() # slides along walls
	if arrived or global_position.distance_to(before) < 0.01:
		moving = false

	if prey and global_position.distance_to(prey.global_position) <= bite_range + prey.radius:
		_eat()


func _animate(direction: Vector2, delta: float) -> void:
	# 3/4 view: face left or right and alternate the walk frames
	if absf(direction.x) > 0.5:
		sprite.flip_h = direction.x < 0.0
	_step += delta * 8.0
	sprite.frame = int(_step) % 2


func _eat() -> void:
	carried_xp += prey.species.xp
	prey.queue_free()
	prey = null
	moving = false


func _prey_at(point: Vector2) -> Animal:
	var best: Animal = null
	var best_dist := INF
	for animal: Animal in get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator"):
		var dist := point.distance_to(animal.sprite.global_position)
		if animal.get_size() < get_size() and dist <= animal.radius + PICK_TOLERANCE and dist < best_dist:
			best = animal
			best_dist = dist
	return best
