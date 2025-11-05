extends CharacterBody3D

@export var speed : float = 5.0

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
