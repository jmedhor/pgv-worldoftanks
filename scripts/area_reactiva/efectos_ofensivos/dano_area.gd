class_name DanoArea extends EfectoReactivo

@export var dano: int = 0
@export var radio: float = 0.0

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	var colisiones := _comprobar_colisiones_aoe(_rea, radio)
	
	_rea.reproducir_vfx()
	
	for entrada in colisiones:
		var entidad = entrada.get("collider")
		_aplicar_dano(dano, entidad)
