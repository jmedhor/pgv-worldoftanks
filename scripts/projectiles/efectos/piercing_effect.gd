class_name PiercingEffect extends ProjectileEffect

@export_range(1, INF) var max_pierces: int = 1
var hit_count: int = 0
var already_hit: Array[Node3D] = []

func on_hit(obj: Projectile, body: Node3D) -> void:
	assert(max_pierces > 0, "Un proyectil penetrante no puede tener un máximo de 0 penetraciones.")
	obj.self_remove = false
	
	if not body in already_hit:
		hit_count += 1
		already_hit.append(body)
	
	if hit_count > max_pierces:
		obj.queue_free()
