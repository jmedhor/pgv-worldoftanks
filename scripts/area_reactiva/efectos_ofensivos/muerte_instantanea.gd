class_name MuerteInstantanea extends EfectoReactivo

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	_aplicar_dano(INF, _body)
