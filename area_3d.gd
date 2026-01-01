extends Area3D

@export var damage := 10
@export var duration := 0.3

func _ready():
	await get_tree().create_timer(duration).timeout
	queue_free()

func _on_body_entered(body):
	if body.name == "Personaje_principal":
		body.recibir_danio(damage)
