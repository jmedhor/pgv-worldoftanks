
extends Node3D
@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/playback")
@onready var barra_vida: ProgressBar = $CanvasLayer/ProgressBar
@export var rango_movimiento := 10.0  
var direccion := 1 
var posicion_inicial := Vector3.ZERO

enum BossState {
	PASIVO_F1,
	AGRESIVO_F1,
	ATAQUE_AREA,
	ATAQUE_ABANICO,

	PASIVO_F2,
	AGRESIVO_F2,
	ATAQUE_AREA_POT,
	ATAQUE_ABANICO_POT,

	DERROTADO
}

@export var max_vida := 1500
@export var velocidad := 6.0
@export var distancia_seguimiento := 50.0

var vida := max_vida
var estado_actual : BossState = BossState.PASIVO_F1

var jugador : Node3D
var jugador_en_vision := false
var puede_disparar := true
var ejecutando_ataque := false
var a = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_tree.active = true
	posicion_inicial = global_position
	$Hitbox.area_entered.connect(_on_hitbox_area_entered)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if a < 0.1:
		state.travel("walk")
	else:
		state.travel("gira_cabeza")

func _physics_process(delta):
	if vida <= 0:
		cambiar_estado(BossState.DERROTADO)
		
	if vida <= max_vida * 0.5 and estado_actual != BossState.AGRESIVO_F2:
		velocidad = 12
		if jugador_en_vision:
			cambiar_estado(BossState.AGRESIVO_F2)
		else:
			cambiar_estado(BossState.PASIVO_F2)
		
	global_position.x += direccion * velocidad * delta

	
	if global_position.x > posicion_inicial.x + rango_movimiento:
		direccion = -1
	elif global_position.x < posicion_inicial.x - rango_movimiento:
		direccion = 1
		
	match estado_actual:
		BossState.PASIVO_F1:
			estado_pasivo(delta)
			
		BossState.AGRESIVO_F1:
			estado_agresivo(delta, false)

		BossState.PASIVO_F2:
			estado_pasivo(delta)
			
		BossState.AGRESIVO_F2:
			estado_agresivo(delta, true)

		BossState.ATAQUE_AREA:
			ataque_area(false)

		BossState.ATAQUE_ABANICO:
			ataque_abanico(false)

		BossState.ATAQUE_AREA_POT:
			ataque_area(true)
	
		BossState.ATAQUE_ABANICO_POT:
			ataque_abanico(true)

		BossState.DERROTADO:
			morir()
func _on_campo_vision_body_entered(body: Node3D) -> void:
	if body.name == "Personaje_principal":
		jugador = body
		jugador_en_vision = true


func _on_campo_vision_body_exited(body: Node3D) -> void:
	if body == jugador:
		jugador_en_vision = false
		
func estado_pasivo(delta):
	
	if jugador_en_vision:
		if vida > max_vida * 0.5:
			cambiar_estado(BossState.AGRESIVO_F1)
		else:
			cambiar_estado(BossState.AGRESIVO_F2)
func estado_agresivo(delta, fase2: bool):
	if not jugador_en_vision or jugador == null:
		if fase2:
			
			cambiar_estado(BossState.PASIVO_F2)
		else:
			cambiar_estado(BossState.PASIVO_F1)
		return

	
	if puede_disparar and not ejecutando_ataque:
		ejecutando_ataque = true
		var eleccion = randi() % 2
		if eleccion == 0:
			#cambiar_estado(BossState.ATAQUE_AREA)
			print("ataque en area")
			await get_tree().create_timer(2.0).timeout
			ejecutando_ataque=false
		else:
			cambiar_estado(BossState.ATAQUE_ABANICO)

func ataque_abanico(potenciado: bool):
	if ejecutando_ataque and not puede_disparar:
		return
	puede_disparar = false
	var num_balas
	var angulo_total
	if potenciado:
		num_balas = 24
		angulo_total = 180
	else:
		num_balas = 12
		angulo_total = 120

	for i in range(num_balas):
		var angulo = lerp(-angulo_total/2, angulo_total/2, float(i)/(num_balas-1))

		disparar_bala(angulo)

	await get_tree().create_timer(4.0).timeout
	puede_disparar = true
	ejecutando_ataque = false
	volver_a_estado_base()

func ataque_area(potenciado: bool):
	puede_disparar = false
	var explosiones
	if potenciado:
		explosiones = 3
	else:
		explosiones =  1

	for i in range(explosiones):
		#instanciar_explosion()
		await get_tree().create_timer(0.4).timeout

	await get_tree().create_timer(1.5).timeout
	puede_disparar = true
	volver_a_estado_base()
func disparar_bala(angulo):
	var bala = preload("res://scenes/projectiles/player/special_aoe_dmg.tscn").instantiate()
	get_parent().add_child(bala)
	var firepoint = $cabeza/CSGCombiner3D/TankFree_Canon
	bala.global_position = firepoint.global_position
	
	
	var dir = firepoint.transform.basis.z.normalized()
	var rot_y = deg_to_rad(angulo)
	var rotated_dir = dir.rotated(Vector3.UP, rot_y).normalized()
	bala.direction = rotated_dir
func cambiar_estado(nuevo):
	if estado_actual == nuevo:
		return
	estado_actual = nuevo
func volver_a_estado_base():
	if vida > max_vida * 0.5:
		cambiar_estado(BossState.AGRESIVO_F1)
	else:
		cambiar_estado(BossState.AGRESIVO_F2)
func morir():
	print("Jefe derrotado")
	queue_free()


func _on_hitbox_area_entered(body: Area3D) -> void:
	if body is Projectile:
		recibir_danio(50)
		body.queue_free()
		
		
func recibir_danio(valor):
	vida -= valor
	actualizar_barra_vida()
func actualizar_barra_vida() -> void:
	if barra_vida:
		barra_vida.value = vida
