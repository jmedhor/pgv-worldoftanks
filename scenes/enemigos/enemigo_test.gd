extends CharacterBody3D

class_name enemigo_test

@export var velocidad_avance : float = 3.0
@export var velocidad_desplazo : float = 1.5
@export var proyectil:PackedScene
@export var tiempoEntreDisparo : float = 2
@export var tiempoEntreMoverse : float = 3
@export var tiempoMoviendose : float = 1
@export var puedeMoverse : bool = false

var rng : RandomNumberGenerator
var derecha : bool = true

func _ready():
	$timerMoverse.start(tiempoEntreMoverse)
	$timerDisparo.start(tiempoEntreDisparo)
	rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	
	var direction = Vector3.ZERO
	
	direction.z += 1.0 * velocidad_avance
	if puedeMoverse == true:
		direction.x += moverse()

	velocity = direction
	
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
	tmp_proyectil.position = $Marker3D.global_position
	tmp_proyectil.add_to_group("Proyectil_Enemigo")
	tmp_proyectil.speed = -15
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
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Proyectil_Jugador"):
		print("Enemigo Alcanzado")
		queue_free()
