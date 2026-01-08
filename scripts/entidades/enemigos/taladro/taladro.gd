extends CharacterBody3D

class_name enemigoTaladro

@export var vida : float = 3.0
@export var estatico : bool = false
@export var velocidad_avance : float = 6.0
@export var tiempoCarga : float = 0.5
@export var puntuacion : float = 150
@export var destruccion:PackedScene
@export var potenciadores: Array[PackedScene]
@export var prob_pot: float = 0.1

@onready var parent = get_parent()

var rng : RandomNumberGenerator
var deltaMultiplier : float = 50
var velocidad_retroceso : float = -(velocidad_avance / 1.5)
var velocidad_carga : float = velocidad_avance * 4

var preparando : bool = false
var atacando : bool = false

var activado : bool = false

func paralizar(segundos: float):
	$timerParalizado.start(segundos)
	$timerCarga.paused = true
	activado = false

func _on_timer_paralizado_timeout():
	activado = true
	$timerCarga.paused = false

func activar_enemigo():
	if !activado:
		activado = true

func _ready():
	rng = RandomNumberGenerator.new()

func _physics_process(delta: float) -> void:

	var direction = Vector3.ZERO
	var nopath = false
	
	if activado:
		if !atacando:
			if !preparando:
				if get_parent() is PathFollow3D:
					nopath = true
					moverse_camino(delta)
				else:
					if !estatico:
						direction.z += 1.0 * velocidad_avance
			else:
				direction.z += 1.0 * velocidad_retroceso
		else:
			direction.z += 1.0 * velocidad_carga
		
		if !nopath:
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

func cargar():
	$TimerCarga.start(tiempoCarga)
	salir_camino()
	preparando = true
	
func recibir_dano(dano: int):
	vida = vida - dano
	if vida <= 0 :
		Global.enemigo_ha_muerto.emit(puntuacion)
		probar_suerte()
		vfx_destruccion()
		queue_free()

func probar_suerte():
	if rng.randf() < prob_pot:
		var potenciador = potenciadores[rng.randf_range(0,2)].instantiate()
		get_tree().current_scene.add_child(potenciador)
		potenciador.global_position = global_position
		potenciador.global_position.y += 0.5

func _on_timer_carga_timeout():
	atacando = true

func _on_zona_ataque_body_entered(body):
	if !preparando:
		cargar()

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
	
