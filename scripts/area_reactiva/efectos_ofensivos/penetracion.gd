class_name Penetracion extends EfectoReactivo

@export var impactos_maximos: int = 0
var impactos: int
var golpeados: Array[Node3D]

func _on_spawn(_rea: AreaReactiva) -> void:
	impactos = 0
	golpeados.clear()
	
	_rea.auto_destruir = false

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	if not _body in golpeados:
		impactos += 1
		golpeados.append(_body)
	
	if impactos >= impactos_maximos:
		_rea.destruir()
