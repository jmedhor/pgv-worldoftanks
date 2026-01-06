class_name Mejora extends EfectoReactivo

const PASO_MEJORA := 1

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	if _body.has_method("mejorar"):
		_body.mejorar(PASO_MEJORA)
