extends CharacterBody3D

class_name enemigoJuggernautBasico

@export var vida : float = 12.0
@export var velocidad_avance : float = 4.0
@export var velocidad_desplazo : float = 2.0
@export var proyectil:PackedScene
@export var tiempoEntreDisparo : float = 3
@export var tiempoEntreMoverse : float = 5
@export var tiempoMoviendose : float = 2
@export var puntuacion : float = 200
@export var destruccion:PackedScene

var puedeMoverse : bool = false
var rng : RandomNumberGenerator
var derecha : bool = true
var deltaMultiplier : float = 50

func _ready():
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
	if tmp_proyectil.has_method("inicializar"):
		tmp_proyectil.inicializar($Marker3D.global_position,Vector3(0,0,1))
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
		Global.enemigo_ha_muerto.emit(puntuacion)
		vfx_destruccion()
		queue_free()
		
func eliminar_borde():
	print("Enemigo se fue por el borde")
	queue_free()

func vfx_destruccion():
	var escena = destruccion.instantiate()
	
	get_tree().current_scene.add_child(escena)
	escena.global_position = global_position

func _on_area_contacto_destruir():
	vfx_destruccion()
	queue_free()
