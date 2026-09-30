class_name Player
extends CharacterBody2D
## Player dino: click-to-move (double click sprints), fighting and hunting, needs, skills, items and upgrades.

signal leveled_up
signal respawned
signal died ## only when it does not come back (survival)

const PICK_TOLERANCE := 8.0 ## extra pixels so small animals are easy to click
const SIZE_SCALE := 0.15 ## sprite growth per size upgrade
const STRIDE := 11.0 ## pixels per walk frame
const STUCK_TIME := 0.5 ## seconds without moving before giving up
const BASE_DAMAGE := 10.0 ## per bite (GAME_SPEC §150)
const ATTACK_INTERVAL := 0.6 ## seconds between bites
const CRIT_CHANCE := 0.05
const HEALTH_PER_LEVEL := 5.0
const BAG_SIZE := 12
const COLORS := [ ## primary colours for the dino, chosen when a save is created
	{"name": "Rust", "color": Color(0.77, 0.4, 0.17)}, {"name": "Moss", "color": Color(0.36, 0.6, 0.25)},
	{"name": "Ocean", "color": Color(0.2, 0.46, 0.76)}, {"name": "Violet", "color": Color(0.52, 0.3, 0.72)},
	{"name": "Crimson", "color": Color(0.78, 0.18, 0.2)}, {"name": "Sand", "color": Color(0.8, 0.68, 0.44)},
	{"name": "Slate", "color": Color(0.4, 0.44, 0.5)}, {"name": "Gold", "color": Color(0.92, 0.72, 0.2)},
]
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
var _build := "" ## the set worn most, shown on the crest
var _sparkle := 0.0
var _ghost := 0.0
var _look := ShaderMaterial.new() ## paints the body, tints and makes the crest glitter
var dino_name := "Dino" ## chosen when the save was created
var respawns := true ## false in survival: a death ends the run
var guard := 0.0 ## seconds nothing can hurt the dino, e.g. right after coming back in versus
var last_attacker := 0 ## the player who bit last (versus)
var color_index := 0 ## one of COLORS

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
	add_to_group("dinos")
	_look.shader = load("res://shaders/hero.gdshader")
	sprite.material = _look
	dino_name = SaveGame.read("profile", "name", "Dino")
	color_index = SaveGame.read("profile", "color", 0)
	Player.paint(_look, color_index)
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
			anim.spin()
			camera.shake(1.5, 0.15)
			SkillFx.swoosh(get_parent(), global_position + Vector2(0, -3), 34.0 + 4.0 * rank, Color(1.0, 0.86, 0.62), anim.facing)
			SkillFx.dust_ring(get_parent(), global_position, 20.0, 6)
			for animal in _animals_near(global_position, 34.0 + 4.0 * rank):
				strike(animal, damage() * (1.0 + 0.25 * rank))
		"roar":
			anim.play("attack", 0.35)
			_stomp()
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
			SkillFx.dust_ring(get_parent(), global_position, 6.0, 4)
		"frenzy":
			frenzy_left = 5.0 + rank
			SkillFx.ring(get_parent(), global_position, 40.0, Fx.HURT, 0.4)
			Fx.text(self, global_position + Vector2(0, -34), "FRENZY", Fx.HURT, 16)
	if has_power("elder"): # the elder's wisdom answers every skill
		SkillFx.ring(get_parent(), global_position, 26.0, Loot.SET_COLORS.elder, 0.4)
	Net.send("fx", [id, global_position, anim.facing]) # the others see the skill too
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
		if crit and not Net.active:
			Fx.hit_stop(get_tree(), 0.04)
		return false
	if not Net.active: # a hit stop would slow the game for everyone
		Fx.hit_stop(get_tree(), 0.06 if rank == 0 else 0.2)
	reward_kill(species, pos, size, rank)
	return true


## What a kill brings: XP, food and loot; in a multiplayer game the others get a share of the XP.
func reward_kill(species: Species, pos: Vector2, size: int, rank: int, share := 1.0) -> void:
	if share < 1.0:
		gain_xp(roundi(species.xp * [1, 3, 8, 20][rank] * share))
		return
	if has_power("tyrant") and not dead: # every kill feeds the tyrant
		var healed := minf(0.15 * max_health(), max_health() - health)
		health += healed
		if healed >= 1.0:
			Fx.text(self, global_position + Vector2(0, -30), "+%d" % roundi(healed), Loot.BETTER)
			for i in 4:
				SkillFx.sparkle(get_parent(), global_position + Vector2(randf_range(-10, 10), randf_range(-26, -4)), Loot.BETTER)
	var xp: int = species.xp * [1, 3, 8, 20][rank]
	carried_xp += xp
	gain_xp(xp)
	hunger = minf(hunger + species.food, max_hunger)
	Loot.drop(get_parent(), pos, size + mini(rank, 2), [0, 1, 3, 5][rank], [0, 1, 2, 3][rank])


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
	if dead or guard > 0.0:
		return
	amount *= 1.0 - armor()
	if from and is_instance_valid(from):
		SkillFx.bite(get_parent(), global_position + Vector2(0, -14), Fx.HURT)
		if has_power("ankylo"): # the spiked hide bites back
			SkillFx.spikes(get_parent(), global_position + Vector2(0, -12), Loot.SET_COLORS.ankylo)
			_look.set_shader_parameter("flash", 1.0)
			create_tween().tween_method(func(v: float) -> void: _look.set_shader_parameter("flash", v), 1.0, 0.0, 0.3)
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
	_update_look()
	health = minf(health, max_health())


## Paints the body of the hero sprite in one of the primary colours (the first is its own).
static func paint(look: ShaderMaterial, index: int) -> void:
	look.set_shader_parameter("recolor", 0.0 if index == 0 else 1.0)
	look.set_shader_parameter("body_color", COLORS[clampi(index, 0, COLORS.size() - 1)].color)


## The build shows (GAME_SPEC §150): two pieces of a set tint the crest in its colour, the whole set makes it glitter.
func _update_look() -> void:
	var counts := Loot.set_counts(equipped)
	_build = ""
	for set_id: String in counts:
		if counts[set_id] >= 2 and (_build == "" or counts[set_id] > counts[_build]):
			_build = set_id
	_look.set_shader_parameter("tint", 0.0 if _build == "" else 1.0)
	_look.set_shader_parameter("shimmer", 0.0 if _build == "" else (1.0 if has_power(_build) else 0.25))
	if _build != "":
		_look.set_shader_parameter("crest_color", Loot.SET_COLORS[_build])


## A point on the tips of the crest, in the world.
func _crest_point() -> Vector2:
	var tip: Vector2 = [Vector2(35.4, 3.0), Vector2(33.4, 7.0), Vector2(31.2, 9.4), Vector2(27.6, 12.0),
		Vector2(23.6, 11.4), Vector2(19.6, 12.0), Vector2(15.4, 12.6)].pick_random()
	return sprite.global_position + Vector2((tip.x - 24.0) * signf(sprite.scale.x), tip.y - 18.0) * absf(sprite.scale.y) / Art.SCALE


## Skills and set powers can be seen (GAME_SPEC §150): sparkles on a full set, a pulsing frenzy, afterimages while charging.
func _update_fx(delta: float) -> void:
	_sparkle -= delta
	if _build != "" and has_power(_build) and _sparkle <= 0.0:
		_sparkle = randf_range(0.15, 0.35)
		SkillFx.sparkle(get_parent(), _crest_point(), Loot.SET_COLORS[_build])
	if frenzy_left > 0.0:
		sprite.self_modulate = Color.WHITE.lerp(Color(1.0, 0.5, 0.45), 0.5 + 0.5 * sin(Time.get_ticks_msec() / 70.0))
		if _sparkle <= 0.0:
			_sparkle = 0.12
			SkillFx.sparkle(get_parent(), global_position + Vector2(randf_range(-9, 9), randf_range(-26, -8)), Fx.HURT)
	else:
		sprite.self_modulate = Color.WHITE
	if _dash_left > 0.0:
		_ghost -= delta
		if _ghost <= 0.0:
			_ghost = 0.035
			SkillFx.afterimage(sprite, Color(1.0, 0.62, 0.32, 0.55))


## Roar starts with a stomp: a hop, and the ground shakes where the dino lands.
func _stomp() -> void:
	var base := sprite.position.y
	var tween := create_tween()
	tween.tween_property(sprite, "position:y", base - 6.0, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "position:y", base, 0.07).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(func() -> void:
		camera.shake(3.5, 0.3)
		SkillFx.ring(get_parent(), global_position, 120.0, Color(1.0, 0.78, 0.42), 0.55)
		SkillFx.ring(get_parent(), global_position, 70.0, Color(1.0, 0.9, 0.7), 0.4)
		SkillFx.dust_ring(get_parent(), global_position, 12.0, 8))


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
	tween.tween_callback(_respawn if respawns else died.emit)


## Back on its feet somewhere else (multiplayer: after a wave or a moment in versus).
func revive(at: Vector2, protection := 0.0) -> void:
	global_position = at
	camera.reset_smoothing()
	health = max_health()
	stamina = max_stamina
	sprite.modulate = Color.WHITE
	_apply_size()
	dead = false
	guard = protection


## What the others need to show this dino (multiplayer): where it is, how it looks and how it fares.
func net_state() -> Array:
	return [global_position, sprite.frame, sprite.scale.x / absf(sprite.scale.y), get_size(), health, max_health(), dead,
		_build, has_power(_build) if _build != "" else false, guard > 0.0]


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
	_update_fx(delta)
	guard = maxf(guard - delta, 0.0)
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
			SkillFx.ring(get_parent(), animal.global_position, 14.0, Color(1.0, 0.7, 0.4), 0.25)
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
	var at := prey.global_position + Vector2(0, -6)
	var parent := get_parent()
	var killed := strike(prey, damage() * (crit_hit if crit else 1.0), crit)
	SkillFx.bite(parent, at, Fx.CRIT if crit else Fx.WHITE, 1.4 if crit else 1.0)
	Net.send("fx", ["bite", at, 1.0 if crit else 0.0])
	if crit and has_power("raptor"):
		SkillFx.ring(parent, at + Vector2(0, 6), 16.0, Loot.SET_COLORS.raptor, 0.3)
	if killed:
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
