class_name DanoDirecto extends EfectoReactivo

@export var dano: float = 0.0

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	_aplicar_dano(dano, _body)
