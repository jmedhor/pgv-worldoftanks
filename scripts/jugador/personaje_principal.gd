extends CharacterBody3D

signal vida_cambiada()
signal cooldown_updated(time_left: float)

@export var speed : float = 100.0
@export var proyectil:PackedScene
@export var especial:PackedScene
@export var tiempoEntreDisparo : float = 0.5
@export var tiempoRecargaEspecial : float = 5.0
@export var vida : float = 5
@export var nivelArma : float = 1
var puedeDisparar : bool = true
var puedeDispararEspecial : bool = true
var pausado : bool = false
var vivo : bool = true
var cadEspecial : String
var escudo : bool = false

@export var rotation_speed := 8.0

@onready var cuerpo = $Cuerpo

var catalogo_especiales = {
	"dmg": preload("res://escenas/proyectiles/jugador/bomba_dano.tscn"),
	"emp": preload("res://escenas/proyectiles/jugador/bomba_pem.tscn"),
}

var catalogo_niveles = {
	"lvl1": preload("res://recursos/proyectiles/jugador/basico/basico_nivel1.tres"),
	"lvl2": preload("res://recursos/proyectiles/jugador/basico/basico_nivel2.tres"),
	"lvl3": preload("res://recursos/proyectiles/jugador/basico/basico_nivel3.tres")
}

func cambiar(arma:String):
	cadEspecial = arma
	if (arma == "emp"):
		especial = catalogo_especiales.get("emp")
	else:
		especial = catalogo_especiales.get("dmg")

func _ready() -> void:
	Global.pausar_juego.connect(_on_pause_changed)

func _process(_delta: float) -> void:
	if not vivo or pausado:
		return

	if not $timerEspecial.is_stopped():
		var tiempo_transcurrido = $timerEspecial.wait_time - $timerEspecial.time_left
		var porcentaje = (tiempo_transcurrido / $timerEspecial.wait_time) * 100
		cooldown_updated.emit(porcentaje)
	
	if Input.is_action_pressed("disparar"):
		disparar("disparar")
	if Input.is_action_just_pressed("especial"):
		disparar("especial")
	if Input.is_action_just_pressed("cambiar"):
		escudo = !escudo
		vida_cambiada.emit()

func _physics_process(delta: float) -> void:
	if not vivo or pausado:
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

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	rotarCuerpo(direction, delta)
	
	velocity = direction * speed * delta
	move_and_slide()
		
func rotarCuerpo(direction, delta):
	var angulo = 0.0

	# CASO 0: Si no nos movemos miramos al frente
	if direction.length_squared() < 0.01:
		angulo = atan2(0, 1) 

	# CASO 1: Hacia arriba
	elif direction.z <= 0.05:
		angulo = atan2(-direction.x, -direction.z)
		
	# CASO 2: Hacia abajo
	else:
		if direction.x > 0.1:
			# Diagonal atras-derecha
			angulo = atan2(1, 1)
			
		elif direction.x < -0.1:
			# Diagonal atras-izquierda
			angulo = atan2(-1, 1)
			
		else:
			# Hacia abajo
			angulo = atan2(0, 1)

	cuerpo.rotation.y = lerp_angle(
		cuerpo.rotation.y,
		angulo,
		delta * rotation_speed
	)
	
	$CollisionShape3D.rotation.y = lerp_angle(
		cuerpo.rotation.y,
		angulo,
		delta * rotation_speed
	)
	
func seleccion_nivel() -> DatosArea:
	var config = catalogo_niveles.get("lvl1")
	if(nivelArma == 2):
		config = catalogo_niveles.get("lvl2")
	elif(nivelArma == 3):
		config = catalogo_niveles.get("lvl3")
	return config

func disparar(accion: String):
	if accion == "disparar" && puedeDisparar:
		var tmp_proyectil = proyectil.instantiate()
		tmp_proyectil.datos = seleccion_nivel()
		$sonido_disparo.play()
		if tmp_proyectil.has_method("inicializar"):
			tmp_proyectil.inicializar($Marker3D.global_position,Vector3(0,0,-1))
		add_sibling(tmp_proyectil)
		
		puedeDisparar = false
		$timerDisparo.start(tiempoEntreDisparo)
	elif accion == "especial": 
		if puedeDispararEspecial:
			var tmp_especial = especial.instantiate()
			if tmp_especial.has_method("inicializar"):
				tmp_especial.inicializar($Marker3D.global_position,Vector3(0,0,-1))
				add_sibling(tmp_especial)
				puedeDispararEspecial = false
				$timerEspecial.start(tiempoRecargaEspecial)
		else:
			print("RECARGANDO")
			$AudioStreamPlayer3D.stop()
			$AudioStreamPlayer3D.play()

func recibir_dano(dano: int):
	if escudo && dano > 0:
		escudo = false
	else:
		vida = vida - dano
	#Global.enemigo_ha_muerto.emit(100)
	if vida <= 0 :
		vivo = false
	vida_cambiada.emit()

func _on_timer_disparo_timeout() -> void:
	puedeDisparar = true
	$timerDisparo.stop()

func _on_timer_especial_timeout() -> void:
	puedeDispararEspecial = true
	cooldown_updated.emit(100)
	$timerEspecial.stop()

func _on_pause_changed(pausa: bool) -> void:
	pausado = pausa
