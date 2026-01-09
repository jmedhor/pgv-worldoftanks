extends CharacterBody3D
@onready var barra_vida: ProgressBar = $CanvasLayer/ProgressBar
@onready var texto_boss: Label = $CanvasLayer/TextoBoss
@onready var rueda_izquierda_b = $TankFree_Wheel_b_left
@onready var rueda_izquierda_f = $TankFree_Wheel_f_left
@onready var rueda_derecha_b = $TankFree_Wheel_b_right
@onready var rueda_derecha_f = $TankFree_Wheel_f_right

var rango_movimiento := 10.0  
@export var area_aviso_scene: PackedScene
@export var explosion_scene: PackedScene
@export var shoot_effect_scene: PackedScene
@onready var canon = $cabeza/CSGCombiner3D/TankFree_Canon
var bala_scene := preload("res://escenas/proyectiles/enemigos/proyectil_ligero.tscn")
var canon_rotacion_inicial: Vector3
var radio_area := 5.0
var direccion := 1 
var posicion_inicial
var radio_rueda := 0.5
var muriendo := false
var en_transicion_fase2 := false
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

@export var max_vida := 500
@export var velocidad := 6.0

var vida := max_vida
var estado_actual : BossState = BossState.PASIVO_F1
var pausado : bool = false
var jugador : Node3D
var jugador_en_vision := false
var puede_disparar := true
var ejecutando_ataque := false
var a = 0
var comenzar_batalla := false

func _ready() -> void:
	posicion_inicial = global_position
	Global.pausar_juego.connect(_on_pause_changed)
	canon_rotacion_inicial = canon.rotation
	barra_vida.visible = false
	barra_vida.modulate.a = 0.0

func _on_pause_changed(pausa: bool) -> void:
	pausado = pausa

func _physics_process(delta):
	if comenzar_batalla and not en_transicion_fase2:
		if vida <= 0:
			cambiar_estado(BossState.DERROTADO)
			
		if vida <= max_vida * 0.5 and estado_actual < BossState.PASIVO_F2:
			iniciar_transicion_fase2()
			return
		
		global_position.x += direccion * velocidad * delta
		rueda_izquierda_f.rotate_x(direccion * velocidad* 0.25 * delta / radio_rueda)
		rueda_izquierda_b.rotate_x(direccion * velocidad* 0.25 * delta / radio_rueda)
		rueda_derecha_f.rotate_x(direccion * velocidad* 0.25 * delta / radio_rueda)
		rueda_derecha_b.rotate_x(direccion * velocidad* 0.25 * delta / radio_rueda)
		
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
	else:
		return

func _on_campo_vision_body_entered(body: Node3D) -> void:
	if body.name == "Personaje_principal":
		jugador = body
		jugador_en_vision = true

func _on_campo_vision_body_exited(body: Node3D) -> void:
	if body == jugador:
		jugador_en_vision = false

func iniciar_transicion_fase2():
	en_transicion_fase2 = true
	puede_disparar = false
	ejecutando_ataque = false
	
	var cam = %Camera3D
	
	cam.camera_shake(0.8, 2.0)  # intensidad 0.8, duración 2 segundos
	
	await get_tree().create_timer(2.0).timeout
	
	velocidad = 12
	cambiar_estado(BossState.PASIVO_F2)
	
	en_transicion_fase2 = false
	puede_disparar = true

func estado_pasivo(_delta):
	if jugador_en_vision:
		if vida > max_vida * 0.5:
			cambiar_estado(BossState.AGRESIVO_F1)
		else:
			cambiar_estado(BossState.AGRESIVO_F2)

func estado_agresivo(_delta, fase2: bool):
	if not jugador_en_vision or jugador == null:
		if fase2:
			cambiar_estado(BossState.PASIVO_F2)
		else:
			cambiar_estado(BossState.PASIVO_F1)
		
		return
	
	if puede_disparar and not ejecutando_ataque:
		ejecutando_ataque = true
		var eleccion = randi() % 2
		
		if fase2:
			if eleccion == 0:
				cambiar_estado(BossState.ATAQUE_AREA_POT)
			else:
				cambiar_estado(BossState.ATAQUE_ABANICO_POT)
		else:
			if eleccion == 0:
				cambiar_estado(BossState.ATAQUE_AREA)
			else:
				cambiar_estado(BossState.ATAQUE_ABANICO)

func ataque_abanico(potenciado: bool):
	if ejecutando_ataque and not puede_disparar:
		return
		
	$Shoot.play()
	puede_disparar = false
	
	var num_balas = 12 if potenciado else 6
	var angulo_total: float = 180 if potenciado else 120
	
	for i in range(num_balas):
		var angulo = lerp(-angulo_total/2, angulo_total/2, float(i)/(num_balas-1))
	
		disparar_bala(angulo)
	
	await get_tree().create_timer(4.0).timeout
	puede_disparar = true
	ejecutando_ataque = false
	volver_a_estado_base()

func ataque_area(potenciado: bool):
	if ejecutando_ataque and not puede_disparar:
		return
	
	puede_disparar = false
	
	var firepoint = $cabeza/CSGCombiner3D/TankFree_Canon
	var dir = firepoint.transform.basis.z.normalized()
	var efecto := shoot_effect_scene.instantiate()
	
	get_parent().add_child(efecto)
	efecto.global_position = firepoint.global_position + dir *0.4
	
	
	var cantidad = 6 if potenciado else 3
	
	var avisos := []
	
	$Shoot.play()
	kick_canon()
	
	await get_tree().create_timer(1.0).timeout
	
	for i in range(cantidad):
		var aviso = area_aviso_scene.instantiate()
		get_parent().add_child(aviso)

		var pos = obtener_posicion_aleatoria()
		aviso.global_position = global_position + pos
		avisos.append(aviso)
	
	await get_tree().create_timer(2).timeout
	
	for aviso in avisos:
		if is_instance_valid(aviso):
			var explosion = explosion_scene.instantiate()
			get_parent().add_child(explosion)
			explosion.global_position = aviso.global_position
			aviso.queue_free()
	
	await get_tree().create_timer(1.0).timeout
	puede_disparar = true
	ejecutando_ataque = false
	volver_a_estado_base()

func disparar_bala(angulo):
	var bala = bala_scene.instantiate()
	get_parent().add_child(bala)
	var firepoint = $cabeza/CSGCombiner3D/TankFree_Canon
	
	kick_canon()
	
	var dir = firepoint.transform.basis.z.normalized()
	var rot_y = deg_to_rad(angulo)
	var rotated_dir = dir.rotated(Vector3.UP, rot_y).normalized()
	var offset = 5
	
	bala.global_position = firepoint.global_position + rotated_dir * offset
	bala.direccion = rotated_dir
	bala.global_position.y -= 2
	
	var efecto = shoot_effect_scene.instantiate()
	get_parent().add_child(efecto)
	efecto.global_position = firepoint.global_position + dir *0.4
	efecto.look_at(efecto.global_position + rotated_dir, Vector3.UP)

func cambiar_estado(nuevo):
	estado_actual = nuevo

func volver_a_estado_base():
	if vida > max_vida * 0.5:
		cambiar_estado(BossState.AGRESIVO_F1)
	else:
		cambiar_estado(BossState.AGRESIVO_F2)

func morir():
	if muriendo:
		return
	
	muriendo = true
	
	velocidad = 0
	puede_disparar = false
	ejecutando_ataque = false
	comenzar_batalla = false
	
	barra_vida.hide()
	print("Jefe derrotado")
	
	var cam = get_viewport().get_camera_3d()
	if cam and cam.has_method("camera_shake"):
		cam.camera_shake(0.6, 1.2)
	
	for i in range(3):
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		
		var offset = Vector3(
			randf_range(-2, 2),
			randf_range(0, 1),
			randf_range(-2, 2)
		)

		explosion.global_position = global_position + offset
		await get_tree().create_timer(0.6).timeout
	
	await get_tree().create_timer(1).timeout
	
	Global.enemigo_ha_muerto.emit(1000)
	Global.finalizar_victoria.emit()
	
	queue_free()

func recibir_dano(dano: int):
	if comenzar_batalla and not en_transicion_fase2:
		vida -= dano
		actualizar_barra_vida()

func actualizar_barra_vida() -> void:
	var tween = create_tween()
	tween.tween_property(
		barra_vida,
		"value",
		vida,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func obtener_posicion_aleatoria() -> Vector3:
	var x = randf_range(-radio_area, radio_area)
	var z = randf_range(5, 25)
	return Vector3(x, -1, z)

func _on_trigger_boss_body_entered(body: Node3D) -> void:
	if body.name == "Personaje_principal":
		get_tree().paused = true
		
		$Animacion_inicial.play("boss_inicio")
		
		$TankMoving.play()
		await get_tree().create_timer(5.05).timeout
		
		$TankMoving.play()
		await get_tree().create_timer(1).timeout
		
		$TankMoving.stop()
		await get_tree().create_timer(1).timeout
		
		$Rotateeffect.play()
		await get_tree().create_timer(3).timeout
		
		$TriggerBoss.monitoring = false
		get_tree().paused = false
		self.process_mode = Node.PROCESS_MODE_PAUSABLE
		
		$BossFightMusic.play()
		var cam = %Camera3D
		cam.camera_shake(0.55, 5)
		mostrar_barra_vida()
		mostrar_texto_boss("Behemoth")
		await get_tree().create_timer(5).timeout
		
		comenzar_batalla = true
		posicion_inicial = Vector3.ZERO
	
func kick_canon():
	var tween = create_tween()
	tween.tween_property(
		canon,
		"rotation:x",
		canon_rotacion_inicial.x - deg_to_rad(20),
		0.05
	)
	tween.tween_property(
		canon,
		"rotation:x",
		canon_rotacion_inicial.x,
		0.12
	)

func mostrar_barra_vida():
	barra_vida.visible = true
	barra_vida.modulate.a = 0.0
	
	var tween := create_tween()
	tween.tween_property(
		barra_vida,
		"modulate:a",
		1.0,
		0.6
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func mostrar_texto_boss(texto: String):
	texto_boss.text = texto
	texto_boss.visible = true
	texto_boss.modulate.a = 0.0
	texto_boss.scale = Vector2(2, 2)
	
	texto_boss.anchor_left = 0
	texto_boss.anchor_top = 0
	texto_boss.anchor_right = 0
	texto_boss.anchor_bottom = 0
	
	texto_boss.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_boss.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	await get_tree().process_frame
	
	var viewport_size = get_viewport().get_visible_rect().size
	var pos_centro = Vector2(
		viewport_size.x / 2 - (texto_boss.size.x * texto_boss.scale.x) / 2,
		viewport_size.y / 2 - (texto_boss.size.y * texto_boss.scale.y) / 2
	)
	
	texto_boss.global_position = pos_centro
	
	var tween = create_tween()
	tween.tween_property(texto_boss, "modulate:a", 1.0, 0.5)
	
	await get_tree().create_timer(3).timeout
	
	var pos_final = Vector2(
		barra_vida.global_position.x + barra_vida.size.x / 2 - texto_boss.size.x / 2 + 80,
		barra_vida.global_position.y - 20  
	)
	
	var tween2 = create_tween()
	tween2.set_parallel(true)
	tween2.tween_property(texto_boss, "global_position", pos_final, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(texto_boss, "scale", Vector2(0.5, 0.5), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
