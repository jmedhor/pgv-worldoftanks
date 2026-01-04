class_name EfectoReactivo extends Resource

const NOMBRE_JUGADOR = "Personaje_principal"

func _comprobar_colisiones_aoe(_rea: AreaReactiva, rad: float) -> Array[Dictionary]:
	var esfera := SphereShape3D.new()
	esfera.radius = rad
	
	var consulta := PhysicsShapeQueryParameters3D.new()
	consulta.shape = esfera
	consulta.transform = Transform3D(Basis(), _rea.global_position)
	consulta.collision_mask = _rea.collision_mask
	
	var espacio := _rea.get_world_3d().direct_space_state
	var resultados := espacio.intersect_shape(consulta)
	
	return resultados

func _aplicar_dano(dano: int, _body: Node3D) -> void:
	if _body.has_method("recibir_dano"):
		_body.recibir_dano(dano)

func _on_spawn(_rea: AreaReactiva) -> void:
	""" Para efectos con consecuencias al aparecer. """

func _on_update(_rea: AreaReactiva) -> void:
	""" Para efectos con consecuencias en cada actualización. """

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	""" Para efectos con consecuencias en colisiones. """

func _on_expired(_rea: AreaReactiva) -> void:
	""" Para efectos con consecuencias en salida de pantalla. """
