class_name Fx
## One-shot effects: particle bursts and a short hit stop that makes bites feel heavy.

const BLOOD := preload("res://scenes/fx/blood.tscn")


static func burst(scene: PackedScene, parent: Node, pos: Vector2) -> void:
	var particles: CPUParticles2D = scene.instantiate()
	particles.position = pos
	parent.add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)


static func hit_stop(tree: SceneTree, seconds := 0.06) -> void:
	Engine.time_scale = 0.05
	await tree.create_timer(seconds, true, false, true).timeout
	Engine.time_scale = 1.0
