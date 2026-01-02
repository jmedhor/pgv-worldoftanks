class_name Mejora extends EfectoReactivo

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	# TODO: Asegurar que solo tiene efecto con las entidades correctas.
	# (De momento lo pongo así para que no de errores)
	
	if _body is CharacterBody3D:
		_body.nivel_arma += 1
