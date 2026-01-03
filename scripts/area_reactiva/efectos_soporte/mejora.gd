class_name Mejora extends EfectoReactivo

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	# TODO: Expandir esta implementación para que funcione con
	# cualquier entidad que contemple mejoras.
	
	if _body.name == NOMBRE_JUGADOR:
		_body.nivel_arma += 1
