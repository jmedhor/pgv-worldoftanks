extends CharacterBody3D

@export var vida : float = 3.0
@export var velocidad_avance : float = 6.0
@export var velocidad_proyectil : float = 10
@export var dano_proyectil : float = 2
@export var tiempoCarga : float = 0.5
@export var puntuacion : float = 150
@export var destruccion:PackedScene

var rng : RandomNumberGenerator
var deltaMultiplier : float = 50
var velocidad_retroceso : float = -(velocidad_avance / 1.5)
var velocidad_carga : float = velocidad_avance * 3.5

var preparando : bool = false
var atacando : bool = false

func _ready():
	pass

func _physics_process(delta: float) -> void:
	
	var direction = Vector3.ZERO
	
	if !atacando:
		if !preparando:
			direction.z += 1.0 * velocidad_avance
		else:
			direction.z += 1.0 * velocidad_retroceso
	else:
		direction.z += 1.0 * velocidad_carga

	velocity = direction * delta * deltaMultiplier
	
	move_and_slide() 

func cargar():
	$TimerCarga.start(tiempoCarga)
	preparando = true
	
func recibir_dano(dano: int):
	print("Enemigo Dañado")
	vida = vida - dano
	if vida <= 0 :
		print("Enemigo Destruido")
		Global.enemigo_ha_muerto.emit(puntuacion)
		vfx_destruccion()
		queue_free()

func _on_timer_carga_timeout():
	atacando = true

func _on_zona_ataque_body_entered(body):
	print("HA ENTRADO URRRAAAAAAAAAA")
	if !preparando:
		cargar()

func eliminar_borde():
	print("Enemigo se fue por el borde")
	Global.enemigo_ha_muerto.emit(puntuacion)
	queue_free()

func vfx_destruccion():
	var escena = destruccion.instantiate()
	
	get_tree().current_scene.add_child(escena)
	escena.global_position = global_position

func _on_area_contacto_destruir():
	vfx_destruccion()
	queue_free()
	
