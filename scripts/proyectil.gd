extends RigidBody3D

@export var speed = 1
@export var objetivo = "Enemigos"
@export var dano = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_collide(-transform.basis.z * delta * speed)
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group(objetivo):
		print("Impacto")
		if body.has_method("recibir_dano"):
			body.recibir_dano(dano)
		queue_free()

func iniciar(nueva_velocidad: float, nuevo_dano: int):
	speed = nueva_velocidad
	dano = nuevo_dano
