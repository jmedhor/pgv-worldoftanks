extends CharacterBody3D

@export var speed : float = 5.0
@export var fall_acceleration: float = 75.0
@export var jump_impulse: float = 20

var target_velocity = Vector3.ZERO

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
		
	if is_on_floor() and Input.is_action_pressed("nueva"):
		target_velocity.y = jump_impulse
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
		
	velocity = target_velocity
	
	move_and_slide() 
