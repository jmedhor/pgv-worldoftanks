extends CharacterBody3D

var max_vida := 700
var velocidad := 2.0
@export var explosion_scene: PackedScene
@export var bala_scene: PackedScene
@onready var rotor = $helicop/Gunship/Rotor
@onready var back_rotor = $helicop/Gunship/Back_Rotor
@onready var helicop = $helicop
@onready var barra_vida: ProgressBar = $CanvasLayer/ProgressBar
@onready var texto_boss: Label = $CanvasLayer/TextoBoss
var radio_movimiento := 8.0
var altura_vuelo := 8.0
var distancia_frontal := 15.0
var amplitud_lateral := 6.0
var amplitud_vertical := 3.0
var suavidad_movimiento := 3.0
var velocidad_carga := 15.0 
var velocidad_rotor := 10.0
var velocidad_back_rotor := 7.5
var dano_contacto := 10
var altura_inicial := 20.0  
var duracion_bajada := 3.0  
var altura_transicion_fase2 := 10.0  
var duracion_transicion_fase2 := 2.0 
var distancia_al_jugador := 15.0 
var haciendo_animacion_entrada := false
var tiempo_animacion := 0.0
var posicion_inicial_entrada: Vector3
var posicion_final_entrada: Vector3
var tiempo_transicion_fase2 := 0.0
var posicion_inicial_fase2: Vector3
var posicion_final_fase2: Vector3

var vida := max_vida
var estado_actual
var objetivo_carga: Vector3
var jugador: Node3D

var puede_atacar := false
var ejecutando_ataque := false
var en_transicion_fase2 := false
var cargando_hacia_objetivo := false
var volviendo_a_posicion := false
var angulo := 0.0
var posicion_objetivo: Vector3
var punto_central_fijo: Vector3
var posicion_antes_carga: Vector3
var esta_cargando := false
var altura_fija_carga := 0.0
var comenzar_batalla:=false
var muriendo = false
enum BossState {
	F1_MOVIMIENTO,
	F1_ATAQUE_LINEAL,
	F2_MOVIMIENTO,
	F2_ATAQUE_LINEAL_POT,
	F2_CARGA,
	DERROTADO
}

func _ready():
	estado_actual = BossState.F1_MOVIMIENTO
	jugador = get_tree().current_scene.get_node("Personaje_principal")
	barra_vida.visible = false
	barra_vida.modulate.a = 0.0
	
	posicion_final_entrada = global_position
	posicion_inicial_entrada = global_position + Vector3(0, altura_inicial, 0)
	

	global_position = posicion_inicial_entrada
	
	
	
	helicop.rotation.y = 0
	helicop.position = Vector3.ZERO
	
	
func _process(delta):
	if rotor:
		rotor.rotate_z(velocidad_rotor * delta)
	if back_rotor:
		back_rotor.rotate_x(velocidad_back_rotor * delta)

func _physics_process(delta):
	if not comenzar_batalla:
		return
	if haciendo_animacion_entrada:
		animacion_entrada(delta)
		return
	
	
	if vida <= 0:
		cambiar_estado(BossState.DERROTADO)

	if vida <= max_vida * 0.5 and estado_actual < BossState.F2_MOVIMIENTO and not en_transicion_fase2:
		iniciar_transicion_fase2()
		return
	

	if en_transicion_fase2:
		animacion_transicion_fase2(delta)
		return

	match estado_actual:
		BossState.F1_MOVIMIENTO:
			movimiento_infinito(delta)
			if not ejecutando_ataque and puede_atacar:
				elegir_ataque_fase1()
		BossState.F1_ATAQUE_LINEAL:
			movimiento_elipse(delta)
		BossState.F2_MOVIMIENTO:
			movimiento_infinito(delta)
			if not ejecutando_ataque and puede_atacar:
				elegir_ataque_fase2()
		BossState.F2_ATAQUE_LINEAL_POT:
			movimiento_infinito(delta)
		BossState.F2_CARGA:
			ejecutar_carga(delta)
		BossState.DERROTADO:
			morir()
	
	
	if not cargando_hacia_objetivo and not volviendo_a_posicion:
		var distancia = global_position.distance_to(posicion_objetivo)
		if distancia > 0.1:
			global_position = global_position.lerp(posicion_objetivo, delta * suavidad_movimiento)
		else:
			global_position = posicion_objetivo
	

	if not cargando_hacia_objetivo and not volviendo_a_posicion:
		var target_dir = (jugador.global_position - global_position).normalized()
		if target_dir.length_squared() > 0.01:
			var current_y = rotation.y
			look_at(global_position + target_dir, Vector3.UP)
			rotation.y = lerp_angle(current_y, rotation.y, delta * suavidad_movimiento)

func animacion_entrada(delta):
	tiempo_animacion += delta
	var progreso = clamp(tiempo_animacion / duracion_bajada, 0.0, 1.0)
	
	
	var t = 1.0 - pow(1.0 - progreso, 3.0)
	
	
	global_position = posicion_inicial_entrada.lerp(posicion_final_entrada, t)
	global_position.z = global_position.z + 4
	
	var target_dir = (jugador.global_position - global_position).normalized()
	if target_dir.length_squared() > 0.01:
		look_at(global_position + target_dir, Vector3.UP)
	
	
	if progreso >= 1.0:
		
		
		punto_central_fijo = global_position
		posicion_objetivo = global_position
		angulo = 0.0
		await get_tree().create_timer(4).timeout
		haciendo_animacion_entrada = false
		puede_atacar = true

func obtener_punto_central() -> Vector3:
	return punto_central_fijo

func elegir_ataque_fase1():
	if puede_atacar and not ejecutando_ataque:
		ejecutando_ataque = true
		cambiar_estado(BossState.F1_ATAQUE_LINEAL)
		ataque_lineal(false)  

func elegir_ataque_fase2():
	if puede_atacar and not ejecutando_ataque:
		ejecutando_ataque = true
		var eleccion = randi() % 2
		if eleccion == 0:
			cambiar_estado(BossState.F2_ATAQUE_LINEAL_POT)
			ataque_lineal(true)  
		else:
			cambiar_estado(BossState.F2_CARGA)
			iniciar_carga() 

func movimiento_elipse(delta):
	angulo += delta * velocidad
	var centro = obtener_punto_central()
	
	var eje_derecha = Vector3.RIGHT
	var eje_adelante = Vector3.FORWARD
	
	var offset_x = cos(angulo) * amplitud_lateral
	var offset_z = sin(angulo) * amplitud_vertical
	
	posicion_objetivo = centro + eje_derecha * offset_x + eje_adelante * offset_z

func movimiento_infinito(delta):
	angulo += delta * velocidad
	var centro = obtener_punto_central()
	
	var a = amplitud_lateral * 1.5
	var b = amplitud_vertical * 5
	var t = angulo
	var denom = 1 + sin(t) * sin(t)
	
	var offset_x = a * cos(t) / denom
	var offset_z = b * sin(t) * cos(t) / denom
	
	posicion_objetivo = centro + Vector3(offset_x, 0, offset_z)

func ataque_lineal(potenciado: bool):
	if not puede_atacar:
		return
	puede_atacar = false

	var rafagas := 3
	var delay = 0.3 if potenciado else 0.15
	$Rafaga.play()
	for i in range(rafagas):
		disparar_bala()
		await get_tree().create_timer(delay).timeout

	
	await get_tree().create_timer(2.0).timeout
	puede_atacar = true
	ejecutando_ataque = false
	volver_a_movimiento()

func iniciar_carga():
	puede_atacar = false
	posicion_antes_carga = global_position
	altura_fija_carga = global_position.y
	objetivo_carga = jugador.global_position
	objetivo_carga.y = altura_fija_carga
	cargando_hacia_objetivo = true
	volviendo_a_posicion = false

func ejecutar_carga(delta):
	if cargando_hacia_objetivo:
		var distancia = global_position.distance_to(objetivo_carga)
		if distancia < 0.5:
			cargando_hacia_objetivo = false
			volviendo_a_posicion = true
		else:
			global_position = global_position.move_toward(objetivo_carga, velocidad_carga * delta)
			global_position.y = altura_fija_carga
	elif volviendo_a_posicion:
		var distancia = global_position.distance_to(posicion_antes_carga)
		if distancia < 0.5:
			volviendo_a_posicion = false
			ejecutando_ataque = false
			puede_atacar = true
			volver_a_movimiento()
		else:
			global_position = global_position.move_toward(posicion_antes_carga, velocidad_carga * delta)
			global_position.y = altura_fija_carga

func disparar_bala():
	var bala_scene := preload("res://escenas/proyectiles/enemigos/proyectil_ligero.tscn")
	var bala = bala_scene.instantiate()
	get_parent().add_child(bala)
	
	var offset = 2.0
	bala.global_position = global_position + (jugador.global_position - global_position).normalized() * offset
	bala.global_position.y += 1.0
	bala.direccion = (jugador.global_position - global_position).normalized()

func iniciar_transicion_fase2():
	en_transicion_fase2 = true
	puede_atacar = false
	ejecutando_ataque = false
	tiempo_transicion_fase2 = 0.0
	posicion_inicial_fase2 = global_position
	posicion_final_fase2 = global_position + Vector3(0, altura_transicion_fase2, 0)
	
	

func animacion_transicion_fase2(delta):
	tiempo_transicion_fase2 += delta
	var duracion_total = duracion_transicion_fase2 * 2  # Subir + bajar
	var progreso = clamp(tiempo_transicion_fase2 / duracion_total, 0.0, 1.0)
	
	if progreso < 0.5:
		var t_subir = progreso * 2.0
		var ease = 1.0 - pow(1.0 - t_subir, 2.0)
		global_position = posicion_inicial_fase2.lerp(posicion_final_fase2, ease)
	else:
		var t_bajar = (progreso - 0.5) * 2.0  
		var ease = pow(t_bajar, 2.0)
		global_position = posicion_final_fase2.lerp(posicion_inicial_fase2, ease)
	
	var target_dir = (jugador.global_position - global_position).normalized()
	if target_dir.length_squared() > 0.01:
		var current_y = rotation.y
		look_at(global_position + target_dir, Vector3.UP)
		rotation.y = lerp_angle(current_y, rotation.y, delta * suavidad_movimiento)
	if progreso >= 1.0:
		en_transicion_fase2 = false
		cambiar_estado(BossState.F2_MOVIMIENTO)
		posicion_objetivo = global_position
		angulo = 0.0
		puede_atacar = true
		

func volver_a_movimiento():
	if vida > max_vida * 0.5:
		cambiar_estado(BossState.F1_MOVIMIENTO)
	else:
		cambiar_estado(BossState.F2_MOVIMIENTO)
	
	angulo += 0.01
	posicion_objetivo = obtener_punto_central()

func recibir_dano(dano: int):
	if comenzar_batalla:
		vida -= dano
		actualizar_barra_vida()

func actualizar_barra_vida() -> void:
	var tween = create_tween()
	tween.tween_property(barra_vida, "value", vida, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func cambiar_estado(nuevo):
	if estado_actual == nuevo:
		return
	estado_actual = nuevo

func morir() -> void:
	
	if muriendo:
		return
	muriendo = true
	velocidad = 0
	
	ejecutando_ataque = false
	comenzar_batalla = false

	
	barra_vida.hide()
	texto_boss.visible = false
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

	
	await get_tree().create_timer(1.0).timeout

	
	if Global.has_signal("enemigo_ha_muerto"):
		Global.enemigo_ha_muerto.emit(1000)
	if Global.has_signal("finalizar_victoria"):
		Global.finalizar_victoria.emit()

	
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "Personaje_principal":
		return
	body.recibir_dano(dano_contacto)


func _on_trigger_boss_body_entered(body: Node3D) -> void:
	
	if body.name == "Personaje_principal":
		print("colision")
		haciendo_animacion_entrada = true
		get_tree().paused = true
		$Helicoptero.play()
		await get_tree().create_timer(1.5).timeout
		
		%TriggerBoss.monitoring = false
		get_tree().paused = false
		var cam = %Camera3D
		cam.camera_shake(0.55, 5)
		mostrar_barra_vida()
		mostrar_texto_boss("Skybreaker")
		comenzar_batalla=true

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
