class_name Player
extends CharacterBody2D
## Player dino: click-to-move (double click sprints), fighting and hunting, needs, skills, items and upgrades.

signal leveled_up
signal respawned

const PICK_TOLERANCE := 8.0 ## extra pixels so small animals are easy to click
const SIZE_SCALE := 0.15 ## sprite growth per size upgrade
const STRIDE := 11.0 ## pixels per walk frame
const STUCK_TIME := 0.5 ## seconds without moving before giving up
const BASE_DAMAGE := 10.0 ## per bite (GAME_SPEC §150)
const ATTACK_INTERVAL := 0.6 ## seconds between bites
const CRIT_CHANCE := 0.05
const HEALTH_PER_LEVEL := 5.0
const BAG_SIZE := 12
const PICKUP_RANGE := 12.0 ## items are picked up by walking over them
const DASH_SPEED := 360.0

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
var total_xp := 0 ## all XP ever earned, decides the level
var upgrades := {"health": 0, "speed": 0, "bite": 0, "size": 0}
var talents := {"sweep": 1, "teeth": 0, "hide": 0, "roar": 0, "charge": 0, "instinct": 0, "frenzy": 0, "vigor": 0}
var cooldowns := {"sweep": 0.0, "roar": 0.0, "charge": 0.0, "frenzy": 0.0}
var bag: Array = [] ## items, see Loot.roll
var equipped := {"teeth": {}, "claws": {}, "hide": {}, "amber": {}}
var health := 100.0
var stamina := 100.0
var hunger := 100.0
var dead := false
var sprinting := false
var temperature := 24.0
var frenzy_left := 0.0
var _burn_flash := 0.0
var _stats := {}
var _powers: Array = [] ## sets worn complete

var target := Vector2.ZERO
var moving := false
var prey: Animal ## the animal the dino is going for
var anim := SpriteAnimator.new()
var _stuck := 0.0
var _attack_cd := 0.0
var _dash_left := 0.0
var _full_warning := 0.0 ## seconds until "bag full" shows again
var _dash_dir := Vector2.ZERO
var _dash_hit: Array = []

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
	total_xp = SaveGame.read("player", "total_xp", 0)
	upgrades.merge(SaveGame.read("player", "upgrades", {}), true)
	talents.merge(SaveGame.read("player", "talents", {}), true)
	bag = SaveGame.read("player", "bag", [])
	equipped.merge(SaveGame.read("player", "equipped", {}), true)
	_update_stats()
	health = max_health()
	stamina = max_stamina
	hunger = max_hunger
	_apply_size()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move"):
		var mouse := event as InputEventMouseButton
		click_at(get_global_mouse_position(), mouse != null and mouse.double_click)
		get_viewport().set_input_as_handled()
	for i in Talents.SKILLS.size():
		if event.is_action_pressed("skill_%d" % (i + 1)):
			use_skill(Talents.SKILLS[i], get_global_mouse_position())
			get_viewport().set_input_as_handled()


## Size class (GAME_SPEC §8): the player starts small and grows with size upgrades.
func get_size() -> int:
	return 2 + upgrades.size


func level() -> int:
	return Talents.level_for(total_xp)


## Worn items add up (GAME_SPEC §150).
func stat(id: String) -> float:
	return _stats.get(id, 0.0)


func max_health() -> float:
	return base_max_health + Upgrades.PLAYER.health.step * upgrades.health + HEALTH_PER_LEVEL * (level() - 1) + stat("health")


func speed() -> float:
	return base_speed + Upgrades.PLAYER.speed.step * upgrades.speed + stat("speed")


func sprint_speed() -> float:
	return base_sprint_speed + Upgrades.PLAYER.speed.step * 1.5 * upgrades.speed + stat("speed")


func bite_range() -> float:
	return base_bite_range + Upgrades.PLAYER.bite.step * upgrades.bite


## Bigger dinos with sharper teeth bite harder.
func damage() -> float:
	return (BASE_DAMAGE + stat("damage")) * (1.0 + 0.25 * upgrades.size) * (1.0 + 0.1 * talents.teeth)


func crit_chance() -> float:
	return CRIT_CHANCE + 0.03 * talents.instinct + stat("crit") / 100.0


func attack_interval() -> float:
	return ATTACK_INTERVAL / (1.0 + stat("attack_speed") / 100.0 + (0.6 if frenzy_left > 0.0 else 0.0))


## Share of incoming bites the hide and armour keep off.
func armor() -> float:
	return minf(0.04 * talents.hide + stat("armor") / 100.0, 0.75)


## Stamina a skill costs: Vigor and the Elder's set make skills cheaper.
func skill_cost(id: String) -> float:
	return Talents.DEFS[id].stamina * (1.0 - 0.08 * talents.vigor) * (0.75 if has_power("elder") else 1.0)


## A set's special power (GAME_SPEC §150): all four pieces are worn.
func has_power(set_id: String) -> bool:
	return _powers.has(set_id)


func life_on_hit() -> float:
	return stat("life_hit") + (2.0 + 2.0 * talents.frenzy if frenzy_left > 0.0 else 0.0)


func upgrade_cost(id: String) -> int:
	return Upgrades.cost(Upgrades.PLAYER[id], upgrades[id])


func can_upgrade(id: String) -> bool:
	return upgrades[id] < Upgrades.PLAYER[id].max and banked_xp >= upgrade_cost(id) and Upgrades.rooted(Upgrades.PLAYER, id, upgrades)


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
	# clicking an animal attacks it, clicking an item walks over to pick it up, anything else just walks there
	prey = _prey_at(point)
	var drop := _drop_at(point)
	var cave := get_tree().get_first_node_in_group("cave") as Cave
	if prey == null and drop:
		target = drop.global_position
	elif prey == null and cave and cave.is_clicked(point):
		# clicking the cave walks right into its entrance
		target = cave.global_position
	moving = true


func enter_cave() -> void:
	# XP is only safe once it is brought home
	banked_xp += carried_xp
	carried_xp = 0


## Every kill brings the dino closer to the next level; each level heals and grants a talent point.
func gain_xp(amount: int) -> void:
	var before := level()
	total_xp += roundi(amount * (1.0 + stat("xp") / 100.0))
	if level() > before:
		health = max_health()
		Fx.text(self, global_position + Vector2(0, -36), "LEVEL %d" % level(), Fx.GOLD, 16)
		leveled_up.emit()


func talent_points() -> int:
	var spent := 0
	for id: String in talents:
		spent += talents[id]
	return level() - spent # the tail sweep comes for free at level 1


func can_learn(id: String) -> bool:
	return talent_points() > 0 and talents[id] < Talents.MAX_RANK and level() >= Talents.TIER_LEVEL[Talents.DEFS[id].tier] \
		and Talents.rooted(id, talents)


func learn(id: String) -> bool:
	if not can_learn(id):
		return false
	talents[id] += 1
	return true


## Skills on the keys 1-4 (GAME_SPEC §150); they cost stamina and have a cooldown.
func use_skill(id: String, aim: Vector2) -> bool:
	var def: Dictionary = Talents.DEFS[id]
	var cost := skill_cost(id)
	if dead or talents[id] == 0 or cooldowns[id] > 0.0 or stamina < cost or _dash_left > 0.0:
		return false
	stamina -= cost
	cooldowns[id] = def.cooldown * (0.6 if has_power("elder") else 1.0)
	var rank: int = talents[id]
	match id:
		"sweep":
			anim.play("attack", 0.2)
			camera.shake(1.5, 0.15)
			for animal in _animals_near(global_position, 34.0 + 4.0 * rank):
				strike(animal, damage() * (1.0 + 0.25 * rank))
		"roar":
			anim.play("attack", 0.35)
			camera.shake(2.5, 0.35)
			Fx.text(self, global_position + Vector2(0, -34), "ROAR", Fx.GOLD, 16)
			for animal in _animals_near(global_position, 130.0):
				animal.panic(global_position, 2.0 + 0.5 * rank)
		"charge":
			_dash_dir = (aim - global_position).normalized()
			if _dash_dir == Vector2.ZERO:
				_dash_dir = Vector2(anim.facing, 0)
			_dash_left = (90.0 + 15.0 * rank) / DASH_SPEED
			_dash_hit.clear()
			prey = null
			moving = false
		"frenzy":
			frenzy_left = 5.0 + rank
			Fx.text(self, global_position + Vector2(0, -34), "FRENZY", Fx.HURT, 16)
	return true


## Bites an animal; eats it and collects its XP, food and loot when it dies. Returns true on a kill.
func strike(animal: Animal, amount: float, crit := false) -> bool:
	health = minf(health + life_on_hit(), max_health())
	Fx.burst(Fx.BLOOD, get_parent(), animal.global_position + Vector2(0, -4))
	Sound.play(get_parent(), "bite", animal.global_position, -2.0)
	var species := animal.species
	var pos := animal.global_position
	var size := animal.get_size()
	var rank := animal.rank
	if not animal.hit(amount, self, crit):
		if crit:
			Fx.hit_stop(get_tree(), 0.04)
		return false
	Fx.hit_stop(get_tree(), 0.06 if rank == 0 else 0.2)
	if has_power("tyrant") and not dead: # every kill feeds the tyrant
		var healed := minf(0.15 * max_health(), max_health() - health)
		health += healed
		if healed >= 1.0:
			Fx.text(self, global_position + Vector2(0, -30), "+%d" % roundi(healed), Loot.BETTER)
	var xp: int = species.xp * [1, 3, 8][rank]
	carried_xp += xp
	gain_xp(xp)
	hunger = minf(hunger + species.food, max_hunger)
	Loot.drop(get_parent(), pos, size + rank, [0, 1, 3][rank], [0, 1, 2][rank])
	return true


## Tells the player that nothing more fits into the bag, at most every two seconds.
func warn_bag_full() -> void:
	if _full_warning <= 0.0:
		_full_warning = 2.0
		Fx.text(self, global_position + Vector2(0, -30), "BAG FULL", Fx.HURT)


func pick_up(drop: Node2D) -> bool:
	if bag.size() >= BAG_SIZE:
		return false
	bag.append(drop.item)
	Fx.text(self, drop.global_position + Vector2(0, -14), drop.item.name, Loot.COLORS[drop.item.rarity])
	drop.queue_free()
	return true


## Wears an item from the bag; whatever was worn in its slot goes back into the bag.
func equip(index: int) -> void:
	var item: Dictionary = bag[index]
	var old: Dictionary = equipped[item.slot]
	equipped[item.slot] = item
	bag.remove_at(index)
	if not old.is_empty():
		bag.insert(index, old)
	_update_stats()


func unequip(slot: String) -> bool:
	if equipped[slot].is_empty() or bag.size() >= BAG_SIZE:
		return false
	bag.append(equipped[slot])
	equipped[slot] = {}
	_update_stats()
	return true


## Items nobody needs are worth a little XP.
func salvage(index: int) -> void:
	carried_xp += Loot.VALUE[bag[index].rarity]
	bag.remove_at(index)


func take_damage(amount: float, from: Animal = null) -> void:
	if dead:
		return
	amount *= 1.0 - armor()
	if from and is_instance_valid(from) and has_power("ankylo"): # the spiked hide bites back
		strike(from, amount * 0.5)
	health -= amount
	camera.shake(3.0, 0.25)
	Fx.burst(Fx.BLOOD, get_parent(), global_position + Vector2(0, -12))
	Fx.number(self, global_position + Vector2(0, -26), amount, Fx.HURT)
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


func _update_stats() -> void:
	_stats = Loot.total(equipped)
	_powers = Loot.set_powers(equipped)
	health = minf(health, max_health())


func _die() -> void:
	if dead:
		return
	dead = true
	moving = false
	prey = null
	_dash_left = 0.0
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
	respawned.emit()


func _apply_size() -> void:
	var s: float = 1.0 + SIZE_SCALE * upgrades.size
	sprite.scale = Vector2(s, s) * Art.SCALE
	sprite.position.y = _sprite_y * s
	shadow.scale = Vector2(s, s) * Art.SCALE


func _physics_process(delta: float) -> void:
	if dead:
		return
	_update_needs(delta)
	if dead:
		return
	for id: String in cooldowns:
		cooldowns[id] = maxf(cooldowns[id] - delta, 0.0)
	frenzy_left = maxf(frenzy_left - delta, 0.0)
	_attack_cd -= delta
	_full_warning -= delta
	for drop: Node2D in get_tree().get_nodes_in_group("loot"):
		if drop.global_position.distance_to(global_position) < PICKUP_RANGE and not drop.is_queued_for_deletion():
			if not pick_up(drop):
				warn_bag_full()
	if _dash_left > 0.0:
		_dash(delta)
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
	if prey and global_position.distance_to(prey.global_position) <= bite_range() + prey.radius:
		# in reach: stand and bite whenever the jaws are ready
		velocity = Vector2.ZERO
		_animate(prey.global_position - global_position, 0.0, delta)
		if _attack_cd <= 0.0:
			_attack()
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


## Charge: rams forward and bites everything in the way once.
func _dash(delta: float) -> void:
	_dash_left -= delta
	velocity = _dash_dir * DASH_SPEED
	_animate(velocity, velocity.length() * delta / STRIDE, delta)
	move_and_slide()
	for animal in _animals_near(global_position, 14.0):
		if not animal in _dash_hit:
			_dash_hit.append(animal)
			strike(animal, damage() * (1.2 + 0.3 * talents.charge))
	if _dash_left <= 0.0:
		velocity = Vector2.ZERO


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
		var recovery: float = stamina_regen * (0.5 if temperature < 5.0 else 1.0) * (1.0 + 0.2 * talents.vigor)
		stamina = minf(stamina + recovery * delta, max_stamina)
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


## Snap; the kill is followed by a moment of chewing.
func _attack() -> void:
	_attack_cd = attack_interval()
	anim.update(sprite, prey.global_position - global_position, 0.0, 0.0)
	anim.play("attack", 0.16)
	var crit := randf() < crit_chance()
	var crit_hit := 3.0 if has_power("raptor") else 2.0
	if strike(prey, damage() * (crit_hit if crit else 1.0), crit):
		anim.then("eat", 0.5)
		prey = null
		moving = false


func _animals_near(pos: Vector2, reach: float) -> Array:
	var near := []
	for animal: Animal in get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator"):
		if not animal.is_queued_for_deletion() and animal.global_position.distance_to(pos) <= reach + animal.radius:
			near.append(animal)
	return near


func _prey_at(point: Vector2) -> Animal:
	var best: Animal = null
	var best_dist := INF
	for animal: Animal in get_tree().get_nodes_in_group("prey") + get_tree().get_nodes_in_group("predator"):
		var dist := point.distance_to(animal.sprite.global_position)
		if dist <= animal.radius + PICK_TOLERANCE and dist < best_dist:
			best = animal
			best_dist = dist
	return best


func _drop_at(point: Vector2) -> Node2D:
	for drop: Node2D in get_tree().get_nodes_in_group("loot"):
		if point.distance_to(drop.global_position + Vector2(0, -6)) <= 10.0:
			return drop
	return null
