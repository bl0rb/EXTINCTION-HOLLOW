class_name RemoteDino
extends Animal
## Another player's dino in a multiplayer game (GAME_SPEC §155): its owner moves it, this copy follows the owner's state.
## In versus it can be bitten; the bite goes to its owner, whose game decides.

const HERO := preload("res://assets/player.png")
const SHADOW := preload("res://assets/shadow.png")
const SHADER := preload("res://shaders/hero.gdshader")

var peer_id := 0
var dino_name := "Dino"
var level := 1
var dead := false
var size_class := 2
var _goal := Vector2.ZERO
var _look := ShaderMaterial.new()
var _build := ""


static func create(id: int, info: Dictionary) -> RemoteDino:
	var dino := RemoteDino.new()
	dino.peer_id = id
	dino.name = "Dino%d" % id
	dino.dino_name = info.get("name", "Dino")
	dino.level = info.get("level", 1)
	var body := Species.new()
	body.size = 2
	body.health = 100.0
	body.xp = 10 + 4 * dino.level
	dino.species = body
	dino.collision_layer = 0
	dino.collision_mask = 0
	var shape := CollisionShape2D.new()
	shape.name = "CollisionShape2D"
	shape.shape = CircleShape2D.new()
	(shape.shape as CircleShape2D).radius = 7.0
	dino.add_child(shape)
	var shadow := Sprite2D.new()
	shadow.texture = SHADOW
	shadow.scale = Vector2.ONE * Art.SCALE
	dino.add_child(shadow)
	var sprite_node := Sprite2D.new()
	sprite_node.name = "Sprite2D"
	sprite_node.texture = HERO
	sprite_node.hframes = 10
	sprite_node.scale = Vector2.ONE * Art.SCALE
	sprite_node.position = Vector2(0, -17)
	dino._look.shader = SHADER
	Player.paint(dino._look, info.get("color", 0))
	sprite_node.material = dino._look
	dino.add_child(sprite_node)
	dino.add_to_group("dinos")
	dino.add_to_group("remote_dinos")
	return dino


func _process(delta: float) -> void:
	global_position = global_position.lerp(_goal, minf(1.0, delta * 15.0))


## The owner's latest state (see Player.net_state).
func apply_state(state: Array) -> void:
	_goal = state[0]
	if global_position == Vector2.ZERO or global_position.distance_to(_goal) > 160.0:
		global_position = _goal # it came back somewhere else
	size_class = state[3]
	var s := (1.0 + Player.SIZE_SCALE * (size_class - 2)) * Art.SCALE
	sprite.frame = state[1]
	sprite.scale = Vector2(s * state[2], s)
	sprite.position.y = -17.0 * s / Art.SCALE
	health = state[4]
	max_health = state[5]
	dead = state[6]
	sprite.modulate = Color(0.45, 0.1, 0.08, 0.5) if dead else Color(1, 1, 1, 0.55 if state[9] else 1.0)
	if state[7] != _build or _look.get_shader_parameter("shimmer") != (1.0 if state[8] else 0.25):
		_build = state[7]
		_look.set_shader_parameter("tint", 0.0 if _build == "" else 1.0)
		_look.set_shader_parameter("shimmer", 0.0 if _build == "" else (1.0 if state[8] else 0.25))
		if _build != "":
			_look.set_shader_parameter("crest_color", Loot.SET_COLORS[_build])


func get_size() -> int:
	return size_class


## A bite in versus: shown here, decided by its owner.
func hit(amount: float, _from: Node2D, crit := false) -> bool:
	if dead:
		return false
	bar_time = 4.0
	Fx.number(self, sprite.global_position + Vector2(0, -12), amount * Net.PVP_DAMAGE, Fx.WHITE, crit)
	sprite.modulate = Color(1.8, 0.7, 0.6)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.2)
	Net.send("pvp", [amount * Net.PVP_DAMAGE, crit], peer_id)
	return false


func panic(_from: Vector2, _seconds: float) -> void:
	pass # a roar does not scare another player's dino


## A skill or a bite of the owner, shown here as well.
func play_fx(kind: String, pos: Vector2, arg: float) -> void:
	var parent := get_parent()
	match kind:
		"bite":
			SkillFx.bite(parent, pos, Fx.CRIT if arg > 0.0 else Fx.WHITE, 1.4 if arg > 0.0 else 1.0)
		"sweep":
			SkillFx.swoosh(parent, pos + Vector2(0, -3), 38.0, Color(1.0, 0.86, 0.62), arg)
			SkillFx.dust_ring(parent, pos, 20.0, 6)
		"roar":
			SkillFx.ring(parent, pos, 120.0, Color(1.0, 0.78, 0.42), 0.55)
			SkillFx.ring(parent, pos, 70.0, Color(1.0, 0.9, 0.7), 0.4)
		"charge":
			SkillFx.dust_ring(parent, pos, 6.0, 4)
		"frenzy":
			SkillFx.ring(parent, pos, 40.0, Fx.HURT, 0.4)
