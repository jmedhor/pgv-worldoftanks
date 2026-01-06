class_name MuerteInstantanea extends EfectoReactivo

# Lo sé, queda horrible, pero no hay otra opcin porque castear INF (float)
# a entero da un errorazo como mi casa de grande en Godot
const DANO_MUERTE := 999

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	print(_body.name)
	_aplicar_dano(DANO_MUERTE, _body)
