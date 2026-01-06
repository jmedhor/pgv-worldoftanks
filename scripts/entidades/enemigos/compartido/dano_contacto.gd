extends Area3D

signal destruir

@export var dano : float = 1

func dano_contacto():
	destruir.emit()
	return dano


func _on_body_entered(body):
	if body.has_method("recibir_dano"):
		body.recibir_dano(dano_contacto())
