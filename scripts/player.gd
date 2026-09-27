class_name Player
extends CharacterBody2D
## Player dino: click-to-move (double click sprints), hunting, needs and upgrades.

const PICK_TOLERANCE := 8.0 ## extra pixels so small animals are easy to click
const SIZE_SCALE := 0.15 ## sprite growth per size upgrade
const STRIDE := 11.0 ## pixels per walk frame
const STUCK_TIME := 0.5 ## seconds without moving before giving up

@export var base_speed := 90.0 ## pixels per second
@export var base_sprint_speed := 140.0
@export var acceleration := 700.0 ## pixels per second²
@export var base_bite_range := 18.0 ## reach from the centre in pixels, added to the prey radius
@export var base_max_health := 100.0
@export var max_stamina := 100.0
@export var sprint_cost := 30.0 ## stamina per second
@export var stamina_regen := 18.0 ## per second while not sprinting
@export var max_hunger := 100.0 ## a full stomach
@export var hunger_rate := 0.6 ## per second
@export var starve_damage := 2.0 ## health per second on an empty stomach
@export var regen := 0.5 ## health per second while well fed
@export var freeze_damage := 1.0 ## health per second when freezing outside the cave

var carried_xp := 0 ## XP collected outside the cave, lost on death
var banked_xp := 0 ## XP brought to the cave, kept permanently
var upgrades := {"health": 0, "speed": 0, "bite": 0, "size": 0}
var health := 100.0
var stamina := 100.0
var hunger := 100.0
var dead := false
var sprinting := false
var temperature := 24.0
var _burn_flash := 0.0

var target := Vector2.ZERO
var moving := false
var prey: Animal
var anim := SpriteAnimator.new()
var _stuck := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var dust: CPUParticles2D = $Dust
@onready var camera: GameCamera = $Camera2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var _cave: Cave = get_tree().get_first_node_in_group("cave")
@onready var _weather: Weather = get_tree().get_first_node_in_group("weather")
@onready var _sprite_y := sprite.position.y


func _ready() -> void:
	banked_xp = SaveGame.read("player", "banked_xp", 0)
	upgrades.merge(SaveGame.read("player", "upgrades", {}), true)
	health = max_health()
	stamina = max_stamina
	hunger = max_hunger
	_apply_size()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		var mouse := event as InputEventMouseButton
		click_at(get_global_mouse_position(), mouse != null and mouse.double_click)
		get_viewport().set_input_as_handled()


## Size class (GAME_SPEC §8): the player starts small and grows with size upgrades.
func get_size() -> int:
	return 2 + upgrades.size


func max_health() -> float:
	return base_max_health + Upgrades.PLAYER.health.step * upgrades.health


func speed() -> float:
	return base_speed + Upgrades.PLAYER.speed.step * upgrades.speed


func sprint_speed() -> float:
	return base_sprint_speed + Upgrades.PLAYER.speed.step * 1.5 * upgrades.speed


func bite_range() -> float:
	return base_bite_range + Upgrades.PLAYER.bite.step * upgrades.bite


func upgrade_cost(id: String) -> int:
	return Upgrades.cost(Upgrades.PLAYER[id], upgrades[id])


func can_upgrade(id: String) -> bool:
	return upgrades[id] < Upgrades.PLAYER[id].max and banked_xp >= upgrade_cost(id)


func buy_upgrade(id: String) -> bool:
	if not can_upgrade(id):
		return false
	banked_xp -= upgrade_cost(id)
	upgrades[id] += 1
	if id == "health":
		health += Upgrades.PLAYER.health.step
	_apply_size()
	return true


## A single click walks, a double click sprints while stamina lasts.
func click_at(point: Vector2, sprint := false) -> void:
	if dead:
		return
	# a new click always replaces the previous target
	target = point
	sprinting = sprint
	_stuck = 0.0
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


func take_damage(amount: float) -> void:
	if dead:
		return
	health -= amount
	camera.shake(3.0, 0.25)
	Fx.burst(Fx.BLOOD, get_parent(), global_position + Vector2(0, -12))
	Fx.hit_stop(get_tree(), 0.08)
	sprite.modulate = Color(1.0, 0.25, 0.2)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.25)
	if health <= 0.0:
		_die()


## Fire and lava hurt continuously, without the knock of a bite.
func burn(amount: float) -> void:
	if dead:
		return
	health -= amount
	_burn_flash -= amount
	if _burn_flash <= 0.0:
		_burn_flash = 6.0
		sprite.modulate = Color(1.0, 0.55, 0.2)
		create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.3)
	if health <= 0.0:
		_die()


## Heavy rain, snow and cold slow the dino down (GAME_SPEC §32-§34), and so do swamp mud and deep snow (§27).
func move_factor() -> float:
	var weather := _weather.speed_factor() if _weather else 1.0
	return weather * (0.9 if temperature < 5.0 else 1.0) * Biomes.FOOTING[Biomes.at(global_position)]


func _die() -> void:
	if dead:
		return
	dead = true
	moving = false
	prey = null
	dust.emitting = false
	# XP that was not brought home is lost
	carried_xp = 0
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color(0.5, 0.08, 0.06), 0.3)
	tween.parallel().tween_property(sprite, "scale:y", 0.35 * sprite.scale.y, 0.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0).set_delay(0.6)
	tween.tween_callback(_respawn)


func _respawn() -> void:
	# the cave is the spawn point
	global_position = (get_tree().get_first_node_in_group("cave") as Cave).global_position
	camera.reset_smoothing()
	health = max_health()
	stamina = max_stamina
	hunger = max_hunger
	sprite.modulate = Color.WHITE
	_apply_size()
	dead = false


func _apply_size() -> void:
	var s: float = 1.0 + SIZE_SCALE * upgrades.size
	sprite.scale = Vector2(s, s)
	sprite.position.y = _sprite_y * s
	shadow.scale = Vector2(s, s)


func _physics_process(delta: float) -> void:
	if dead:
		return
	_update_needs(delta)
	if dead:
		return
	if is_instance_valid(prey):
		# keep chasing the selected prey wherever it runs
		target = prey.global_position
		moving = true
	elif prey != null:
		prey = null
		moving = false
	var sprint := sprinting and moving and stamina > 0.0
	dust.emitting = sprint
	if not moving or anim.busy():
		velocity = Vector2.ZERO
		_animate(Vector2.ZERO, 0.0, delta)
		return

	# follow the navigation path around obstacles, speed up and ease into the target
	var speed := (sprint_speed() if sprint else speed()) * move_factor()
	nav.target_position = target
	var to_next := nav.get_next_path_position() - global_position
	if to_next.length() < 0.01:
		to_next = target - global_position # no path yet: head straight for it
	var dist := global_position.distance_to(target)
	var desired := to_next.normalized() * speed * clampf(dist / 12.0, 0.3, 1.0)
	# brake harder when turning back, and face the way the dino really moves
	velocity = velocity.move_toward(desired, acceleration * (2.0 if velocity.dot(desired) < 0.0 else 1.0) * delta)
	_animate(velocity, velocity.length() * delta / STRIDE, delta)
	if dist <= maxf(velocity.length() * delta, 0.5):
		velocity = (target - global_position) / delta
		move_and_slide()
		velocity = Vector2.ZERO
		moving = false
	else:
		var before := global_position
		move_and_slide() # slides along walls
		# an unreachable target (in the water, on a rock): stop as close as the path gets
		if nav.is_navigation_finished() and nav.get_final_position().distance_to(target) > 2.0:
			moving = false
		_stuck = _stuck + delta if global_position.distance_to(before) < 0.05 else 0.0
		if _stuck > STUCK_TIME:
			moving = false

	if prey and global_position.distance_to(prey.global_position) <= bite_range() + prey.radius:
		_bite()


## Hunger drains while moving outside the cave (GAME_SPEC §7); stamina is spent by sprinting and recovers otherwise.
func _update_needs(delta: float) -> void:
	if sprinting and moving and stamina > 0.0:
		stamina = maxf(stamina - sprint_cost * delta, 0.0)
		if stamina == 0.0:
			sprinting = false
	var in_cave := _cave.overlaps_body(self)
	# the cave fire keeps it warm inside
	temperature = maxf(_weather.temperature_at(global_position), 20.0) if in_cave else _weather.temperature_at(global_position)
	if not (sprinting and moving and stamina > 0.0):
		stamina = minf(stamina + stamina_regen * (0.5 if temperature < 5.0 else 1.0) * delta, max_stamina)
	var freezing := temperature < -4.0 and not in_cave
	if freezing:
		health -= freeze_damage * delta
		if health <= 0.0:
			_die()
			return
	if moving and not in_cave:
		hunger = maxf(hunger - hunger_rate * delta, 0.0)
	if hunger == 0.0 and not in_cave:
		health -= starve_damage * delta
		if health <= 0.0:
			_die()
	elif hunger > max_hunger * 0.6 and not freezing:
		health = minf(health + regen * delta, max_health())


func _animate(direction: Vector2, steps: float, delta: float) -> void:
	anim.update(sprite, direction, steps, delta)


## Snap, then stand and chew for a moment.
func _bite() -> void:
	carried_xp += prey.species.xp
	hunger = minf(hunger + prey.species.food, max_hunger)
	anim.update(sprite, prey.global_position - global_position, 0.0, 0.0)
	anim.play("attack", 0.16)
	anim.then("eat", 0.5)
	Fx.burst(Fx.BLOOD, get_parent(), prey.global_position + Vector2(0, -4))
	Fx.hit_stop(get_tree())
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
