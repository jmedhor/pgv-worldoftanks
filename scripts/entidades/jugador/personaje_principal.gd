extends CharacterBody3D

signal vida_cambiada()
signal cooldown_updated(time_left: float)

const MAX_NIVEL: int = Global.MAX_NIVEL_JUGADOR
const MAX_VIDA: int = Global.MAX_VIDA_JUGADOR

@export var speed : float = 100.0
@export var proyectil:PackedScene
@export var especial:PackedScene
@export var tiempoEntreDisparo : float = 0.5
@export var tiempoRecargaEspecial : float = 5.0
@export var vida : float = MAX_VIDA
@export var _nivel_arma : int = 0
@export var rotation_speed := 8.0
var puedeDisparar : bool = true
var puedeDispararEspecial : bool = true
var pausado : bool = false
var vivo : bool = true
var cadEspecial : String
var escudo : bool = false

var choque_4 : bool = false
var choque_7 : bool = false

@onready var cuerpo = $Cuerpo

var catalogo_especiales = {
	"dmg": preload("res://escenas/proyectiles/jugador/bomba_dano.tscn"),
	"emp": preload("res://escenas/proyectiles/jugador/bomba_pem.tscn"),
}

var catalogo_niveles = [
	preload("res://recursos/proyectiles/jugador/basico/basico_nivel1.tres"),
	preload("res://recursos/proyectiles/jugador/basico/basico_nivel2.tres"),
	preload("res://recursos/proyectiles/jugador/basico/basico_nivel3.tres")
 ]


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

func _physics_process(delta: float) -> void:
	if not vivo or pausado:
		return

	#revisar_colision_doble()

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

#Primer intento, funciona pero se lanza una vez por frame 
func revisar_colision_doble():
	#Resulta que Area3D puede obtener los cuerpos con los que choca, los obtenemos
	var cuerpos = $DetectorAplastamiento.get_overlapping_bodies()
	var tocando_obstaculo = false
	var tocando_limite = false
	
	#Probamos si alguno de los objetos que colisionan estan en capa 4 o 7 (bit 3 y 6)
	for colision in cuerpos:
		if colision.collision_layer & (1 << 3):
			tocando_obstaculo = true
		if colision.collision_layer & (1 << 6):
			tocando_limite = true
			
	# Si chocamos con los 2 a la vez pues chico, has muerto...
	if tocando_obstaculo and tocando_limite:
		vida = 0
		vivo = false
		vida_cambiada.emit()

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

func mejorar(mejora: int) -> void:
	if _nivel_arma < MAX_NIVEL:
		_nivel_arma += mejora

func reset_nivel() -> void:
	_nivel_arma = 1

func activar_escudo() -> void:
	escudo = true
	vida_cambiada.emit()

func curar(puntos: int) -> void:
	vida = min(MAX_VIDA, vida + puntos)
	vida_cambiada.emit()

func set_nivel(nivel:int):
	if _nivel_arma < MAX_NIVEL:
		_nivel_arma = nivel

func get_nivel():
	return _nivel_arma

func disparar(accion: String):
	if accion == "disparar" && puedeDisparar:
		var tmp_proyectil = proyectil.instantiate()
		tmp_proyectil.datos = catalogo_niveles.get(_nivel_arma)
		var recurso = catalogo_niveles.get(_nivel_arma)
		if recurso:
			print(recurso.resource_path.get_file()) # Esto imprimirá algo como "dmg.png"
		$sonido_disparo.play()
		if tmp_proyectil.has_method("inicializar"):
			tmp_proyectil.inicializar($Marker3D.global_position,Vector3(0,0,-1))
		add_sibling(tmp_proyectil)
		
		puedeDisparar = false
		$timerDisparo.start(tiempoEntreDisparo)
	elif accion == "especial": 
		if puedeDispararEspecial:
			var tmp_especial = especial.instantiate()
			$sonido_especial.play()
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
	if escudo:
		escudo = false
	else:
		vida -= dano
	
	vivo = vida > 0
	
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

func _on_detector_aplastamiento_body_entered(body: Node3D) -> void:
	if body.collision_layer & (1 << 3): # Capa 4
		choque_4 = true
	if body.collision_layer & (1 << 6): # Capa 7
		choque_7 = true
	
	if choque_4 and choque_7:
		vida = 0
		vivo = false
		vida_cambiada.emit()

func _on_detector_aplastamiento_body_exited(body: Node3D) -> void:
	if body.collision_layer & (1 << 3): # Capa 4
		choque_4 = false
	if body.collision_layer & (1 << 6): # Capa 7
		choque_7 = false
