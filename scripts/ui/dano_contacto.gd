extends Area3D

signal destruir

@export var dano : float = 1

func dano_contacto():
	destruir.emit()
	return dano
