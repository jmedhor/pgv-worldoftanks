class_name ParalisisArea extends EfectoReactivo

@export var radio: float = 0.0
@export var segundos_duracion: float = 0.0

func _on_hit(_rea: AreaReactiva, _body: Node3D) -> void:
	var colisiones := _comprobar_colisiones_aoe(_rea, radio)
	
	_rea.reproducir_vfx()
	
	for entrada in colisiones:
		var entidad = entrada.get("collider")
		
		if entidad.has_method("paralizar"):
			entidad.paralizar(segundos_duracion)
