class_name Player
extends CharacterBody2D
## Player dino: click-to-move (double click sprints), hunting, needs and upgrades.

const PICK_TOLERANCE := 8.0 ## extra pixels so small animals are easy to click
const SIZE_SCALE := 0.15 ## sprite growth per size upgrade
const STRIDE := 11.0 ## pixels per walk frame
const DETOUR_TIME := 0.4 ## seconds without getting closer to the target before giving up

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

var carried_xp := 0 ## XP collected outside the cave, lost on death
var banked_xp := 0 ## XP brought to the cave, kept permanently
var upgrades := {"health": 0, "speed": 0, "bite": 0, "size": 0}
var health := 100.0
var stamina := 100.0
var hunger := 100.0
var dead := false
var sprinting := false

var target := Vector2.ZERO
var moving := false
var prey: Animal
var anim := SpriteAnimator.new()
var _detour := 0.0
var _best_dist := INF

@onready var sprite: Sprite2D = $Sprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var dust: CPUParticles2D = $Dust
@onready var camera: GameCamera = $Camera2D
@onready var _cave: Cave = get_tree().get_first_node_in_group("cave")
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
	_best_dist = INF
	_detour = 0.0
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


func _die() -> void:
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
		_best_dist = INF # a moving target: keep going
	elif prey != null:
		prey = null
		moving = false
	var sprint := sprinting and moving and stamina > 0.0
	dust.emitting = sprint
	if not moving or anim.busy():
		velocity = Vector2.ZERO
		_animate(Vector2.ZERO, 0.0, delta)
		return

	# speed up and ease into the target instead of starting and stopping dead
	var speed := sprint_speed() if sprint else speed()
	var to_target := target - global_position
	var dist := to_target.length()
	velocity = velocity.move_toward(to_target.normalized() * speed * clampf(dist / 12.0, 0.3, 1.0), acceleration * delta)
	_animate(to_target, velocity.length() * delta / STRIDE, delta)
	if dist <= maxf(velocity.length() * delta, 0.5):
		velocity = to_target / delta
		move_and_slide()
		velocity = Vector2.ZERO
		moving = false
	else:
		var before := global_position
		move_and_slide() # slides along walls
		if global_position.distance_to(before) < 0.01:
			# blocked head-on: slip around the obstacle
			for side in [1.0, -1.0]:
				velocity = to_target.normalized().rotated(side * PI / 2.5) * speed
				move_and_slide()
				if global_position.distance_to(before) > 0.3:
					break
		# give up once the target has not come closer for a moment
		var left := global_position.distance_to(target)
		if left < _best_dist - 0.5:
			_best_dist = left
			_detour = 0.0
		else:
			_detour += delta
			if _detour > DETOUR_TIME:
				moving = false

	if prey and global_position.distance_to(prey.global_position) <= bite_range() + prey.radius:
		_bite()


## Hunger drains while moving outside the cave (GAME_SPEC §7); stamina is spent by sprinting and recovers otherwise.
func _update_needs(delta: float) -> void:
	if sprinting and moving and stamina > 0.0:
		stamina = maxf(stamina - sprint_cost * delta, 0.0)
		if stamina == 0.0:
			sprinting = false
	else:
		stamina = minf(stamina + stamina_regen * delta, max_stamina)
	var in_cave := _cave.overlaps_body(self)
	if moving and not in_cave:
		hunger = maxf(hunger - hunger_rate * delta, 0.0)
	if hunger == 0.0 and not in_cave:
		health -= starve_damage * delta
		if health <= 0.0:
			_die()
	elif hunger > max_hunger * 0.6:
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
