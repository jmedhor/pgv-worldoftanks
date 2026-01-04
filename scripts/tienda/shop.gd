extends Node3D

func _on_colision_tienda_area_body_entered(body: Node3D) -> void:
	if body.name == "Personaje_principal" :
		Global.is_shopping.emit(true)

func _on_colision_tienda_area_body_exited(body: Node3D) -> void:
	if body.name == "Personaje_principal" :
		Global.is_shopping.emit(false)
