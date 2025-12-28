class_name ProjectileEffect extends Resource

func _check_collisions_aoe(rad: float, obj: Projectile) -> Array[Dictionary]:
	var sphere := SphereShape3D.new()
	sphere.radius = rad
	
	var query := PhysicsShapeQueryParameters3D.new()
	query.shape = sphere
	query.transform = Transform3D(Basis(), obj.global_position)
	query.collision_mask = obj.collision_mask
	
	var space := obj.get_world_3d().direct_space_state
	var results := space.intersect_shape(query)
	
	return results

func _apply_damage(dmg: float, body: Node3D) -> void:
	print("Aplico daño: ", dmg, " a ", body.name)
	
	# TODO: adaptar esto al código usado en el proyecto.
	
	if body.has_method("aplicar_dano"):
		body.aplicar_dano(dmg)
	elif body.has_method("recibir_dano"):
		body.recibir_dano(dmg)

func on_spawn(_obj: Projectile) -> void: pass
func on_update(_obj: Projectile, _delta: float) -> void: pass
func on_hit(_obj: Projectile, _body: Node3D) -> void: pass
func on_expire(_obj: Projectile) -> void: pass
