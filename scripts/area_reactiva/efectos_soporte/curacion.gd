class_name Curacion extends EfectoReactivo

@export_range(0.0, INF) var vida_curada: float = 0.0

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	_aplicar_dano(-vida_curada, _body)
