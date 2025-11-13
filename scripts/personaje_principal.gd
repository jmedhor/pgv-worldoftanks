extends CharacterBody3D

@export var speed : float = 5.0
@export var proyectil:PackedScene

func _physics_process(delta: float) -> void:
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		direction.z -= 1.0
	if Input.is_action_pressed("right"):
		direction.x += 1.0
	if Input.is_action_pressed("left"):
		direction.x -= 1.0	
	if Input.is_action_pressed("backward"):
		direction.z += 1.0	
	velocity = direction  * speed
	
	move_and_slide() 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("disparar"):
		disparar()

func disparar():
	var tmp_proyectil = proyectil.instantiate()
	tmp_proyectil.position = $Marker3D.global_position
	add_sibling(tmp_proyectil)
	
