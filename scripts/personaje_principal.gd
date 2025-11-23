extends CharacterBody3D

@export var speed : float = 5.0
@export var proyectil:PackedScene
@export var tiempoEntreDisparo : float = 0.5
var puedeDisparar : bool = true


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
	
	if Input.is_action_pressed("disparar"):
		disparar()
	

func disparar():
	if puedeDisparar:
		var tmp_proyectil = proyectil.instantiate()
		tmp_proyectil.position = $Marker3D.global_position
		tmp_proyectil.add_to_group("Proyectil_Jugador")
		tmp_proyectil.speed = 15
		add_sibling(tmp_proyectil)
		
		puedeDisparar = false
		$timerDisparo.start(tiempoEntreDisparo)
	

func _on_timer_disparo_timeout() -> void:
	puedeDisparar = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Proyectil_Enemigo"):
		print("Nos Han Dado")
