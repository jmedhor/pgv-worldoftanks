class_name Escudo extends EfectoReactivo

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	if _body.has_method("activar_escudo"):
		_body.activar_escudo()
