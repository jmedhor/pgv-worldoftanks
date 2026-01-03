class_name Escudo extends EfectoReactivo

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	# TODO: Expandir esta implementación para que funcione con
	# cualquier entidad que pueda tener escudo.
	
	if _body.name == NOMBRE_JUGADOR:
		_body.escudo = true
