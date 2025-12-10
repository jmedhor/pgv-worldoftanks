extends CharacterBody3D

class_name enemigoMechaBasico

@export var vida : float = 5.0
@export var velocidad_avance : float = 6.0
@export var velocidad_desplazo : float = 1.0	#Queda raro sin animacion lol
@export var proyectil:PackedScene
@export var velocidad_proyectil : float = 20
@export var dano_proyectil : float = 1
@export var tiempoEntreDisparo : float = 0.5
@export var tiempoEntreMoverse : float = 4
@export var tiempoMoviendose : float = 1
@export var puedeMoverse : bool = false

var rng : RandomNumberGenerator
var canonDerecho : bool = true
var derecha : bool = true
var deltaMultiplier : float = 50

func _ready():
	print("mecha")
	$timerMoverse.start(tiempoEntreMoverse)
	$timerDisparo.start(tiempoEntreDisparo)
	rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	
	var direction = Vector3.ZERO
	
	direction.z += 1.0 * velocidad_avance
	if puedeMoverse == true:
		direction.x += moverse()

	velocity = direction * delta * deltaMultiplier
	
	move_and_slide() 

func moverse():
	var x_factor : float = 0.0
	if derecha:
		x_factor = 1.0 * velocidad_desplazo
	else: 
		x_factor = -1.0 * velocidad_desplazo
	return x_factor

func disparar():
	var tmp_proyectil = proyectil.instantiate()
	if canonDerecho:
		tmp_proyectil.position = $Canon1.global_position
		canonDerecho = false
	else :
		tmp_proyectil.position = $Canon2.global_position
		canonDerecho = true		
	tmp_proyectil.objetivo = "Jugador"
	tmp_proyectil.speed = -velocidad_proyectil
	tmp_proyectil.dano = dano_proyectil
	add_sibling(tmp_proyectil)
	
	$timerDisparo.start(tiempoEntreDisparo)
	
func _on_timer_disparo_timeout() -> void:
	disparar()
	
func _on_timer_moverse_timeout() -> void:
	puedeMoverse = true
	derecha = rng.randf() < 0.5
	$timerMoviendose.start(tiempoMoviendose)
	
func _on_timer_moviendose_timeout() -> void:
	puedeMoverse = false
	
func recibir_dano(dano: int):
	print("Enemigo Dañado")
	vida = vida - dano
	if vida <= 0 :
		print("Enemigo Destruido")
		queue_free()
