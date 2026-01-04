class_name Curacion extends EfectoReactivo

@export var vida_curada: float = 0.0

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	if _body.has_method("curar"):
		_body.curar(vida_curada)
