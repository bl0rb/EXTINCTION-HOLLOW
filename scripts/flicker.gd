extends PointLight2D
## Flickering fire light.

@export var strength := 0.15

var _noise := FastNoiseLite.new()
var _time := 0.0

@onready var _energy := energy
@onready var _scale := texture_scale


func _process(delta: float) -> void:
	_time += delta
	var n := _noise.get_noise_1d(_time * 400.0)
	energy = _energy * (1.0 + n * strength * 2.0)
	texture_scale = _scale * (1.0 + n * strength * 0.4)
