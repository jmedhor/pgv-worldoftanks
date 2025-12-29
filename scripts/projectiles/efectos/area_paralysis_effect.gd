class_name AreaParalysisEffect extends ProjectileEffect

@export var radius: float = 0.0
@export var duration: float = 0.0

func on_hit(obj: Projectile, _body: Node3D) -> void:
	var hits := _check_collisions_aoe(radius, obj)
	
	obj.play_vfx()
	
	for entity in hits:
		var col = entity.get("collider")
		
		if col.has_method("paralizar"):
			col.paralizar(duration)
