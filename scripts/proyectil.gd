extends RigidBody3D

@export var speed = 1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("dumbtest")
	print(self.is_in_group("Proyectil_Jugador"))
	print(self.is_in_group("Proyectil_Enemigo"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_collide(-transform.basis.z * delta * speed)
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if (self.is_in_group("Proyectil_Jugador") and body.is_in_group("Enemigos")):
		pass
		#print("Impacto")
		#queue_free()
