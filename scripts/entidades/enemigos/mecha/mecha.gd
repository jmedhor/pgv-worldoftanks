extends CharacterBody3D

class_name enemigoMecha

@export var vida : float = 5.0
@export var estatico : bool = false
@export var velocidad_avance : float = 6.0
@export var velocidad_desplazo : float = 1.0	#Queda raro sin animacion lol
@export var proyectil:PackedScene
@export var tiempoEntreDisparo : float = 0.5
@export var tiempoEntreMoverse : float = 4
@export var tiempoMoviendose : float = 1
@export var puntuacion : float = 350
@export var destruccion:PackedScene
@export var potenciadores: Array[PackedScene]
@export var prob_pot: float = 25

@onready var parent = get_parent()

var puedeMoverse : bool = false
var rng : RandomNumberGenerator
var canonDerecho : bool = true
var derecha : bool = true
var deltaMultiplier : float = 50

func _ready():
	$timerMoverse.start(tiempoEntreMoverse)
	$timerDisparo.start(tiempoEntreDisparo)
	rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:
	
	if get_parent() is PathFollow3D:
		moverse_camino(delta)
	else:
		if !estatico:
			var direction = Vector3.ZERO
			
			direction.z += 1.0 * velocidad_avance
			if puedeMoverse == true:
				direction.x += moverse()

			velocity = direction * delta * deltaMultiplier
			
			move_and_slide() 

func moverse_camino(delta: float) -> void:
	var curva = parent.get_parent().get_curve()
	var avance = velocidad_avance*delta
	if curva.closed == true:
		parent.set_progress(parent.get_progress() + avance)
	else:
		var max_length = curva.get_baked_length()
		if parent.get_progress()+avance < max_length:
			parent.set_progress(parent.get_progress() + avance)
		else:
			parent.set_progress(max_length)
			salir_camino()
			
func salir_camino():
	var escena = get_tree().current_scene
	var pos = self.global_position
	parent.remove_child(self)
	escena.add_child(self)
	self.global_position = pos

func moverse():
	var x_factor : float = 0.0
	if derecha:
		x_factor = 1.0 * velocidad_desplazo
	else: 
		x_factor = -1.0 * velocidad_desplazo
	return x_factor

func disparar():
	var tmp_proyectil = proyectil.instantiate()
	var pos_proyectil
	if canonDerecho:
		pos_proyectil = $Canon1.global_position
		canonDerecho = false
	else :
		pos_proyectil = $Canon2.global_position
		canonDerecho = true		
	if tmp_proyectil.has_method("inicializar"):
		tmp_proyectil.inicializar(pos_proyectil,Vector3(0,0,1))
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
	vida = vida - dano
	if vida <= 0 :
		Global.enemigo_ha_muerto.emit(puntuacion)
		probar_suerte()
		vfx_destruccion()
		queue_free()

func probar_suerte():
	if rng.randf() < prob_pot*0.01:
		var potenciador = potenciadores[rng.randf_range(0,2)].instantiate()
		get_tree().current_scene.add_child(potenciador)
		potenciador.global_position = global_position
		potenciador.global_position.y += 0.5

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
