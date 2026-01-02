extends Node3D

@export var damage := 40
@onready var fire = $Fire


func _ready():
	fire.emitting = true
	await get_tree().create_timer(fire.lifetime).timeout
	queue_free()

func _on_Area3D_body_entered(body):
	if body.name == "Personaje_principal":
		body.recibir_danio(damage)
