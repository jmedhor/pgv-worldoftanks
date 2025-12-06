extends CharacterBody3D

signal vida_cambiada(nueva_vida)
signal he_muerto

@export var speed : float = 100.0
@export var proyectil:PackedScene
@export var tiempoEntreDisparo : float = 0.5
@export var vida : float = 5
var puedeDisparar : bool = true
var vivo : bool = true

func _physics_process(delta: float) -> void:
	
	if not vivo:
		return
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		direction.z -= 1.0
	if Input.is_action_pressed("right"):
		direction.x += 1.0
	if Input.is_action_pressed("left"):
		direction.x -= 1.0
	if Input.is_action_pressed("backward"):
		direction.z += 1.0
	velocity = direction  * speed * delta
	
	move_and_slide() 
	
	if Input.is_action_pressed("disparar"):
		disparar()
	

func disparar():
	if puedeDisparar:
		var tmp_proyectil = proyectil.instantiate()
		tmp_proyectil.position = $Marker3D.global_position
		if tmp_proyectil.has_method("iniciar"):
			tmp_proyectil.iniciar(5,5)
		add_sibling(tmp_proyectil)
		
		puedeDisparar = false
		$timerDisparo.start(tiempoEntreDisparo)
	

func _on_timer_disparo_timeout() -> void:
	puedeDisparar = true

func recibir_dano(dano: int):
	print("Ouch")
	vida = vida - dano
	vida_cambiada.emit(vida)
	if vida <= 0 :
		print("Me morio")
		vivo = false
		he_muerto.emit()
