extends Node

class_name NivelBase

var pausa := false
var timer1 : SceneTreeTimer
var timer2 : SceneTreeTimer
@onready var rect_brillo = $ColorRectBrillo
@onready var hud = $hud
@onready var jugador = $Personaje_principal
@onready var tienda = $Tienda
@export var escena_game_over : PackedScene
@export var escena_victoria : PackedScene
var objeto_curacion = preload("res://escenas/potenciadores/objeto_curacion.tscn")
var ruta_menu_principal = preload("res://escenas/menu_principal/menu_principal.tscn")
var tiempo_jugado : float
var puntos : int
var partida_activa : bool = true
var ultima_vida : int
var combo_maximo : int
var combo_actual : int
var puede_comprar : bool = false
var tienda_abierta : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	reiniciar_pausa()
	
	%AnimationPlayer.play("mov_camara")
	%timer1.start()
	tiempo_jugado = 0
	puntos = 1000
	combo_actual = 1
	combo_maximo = 1
	
	inicializar_jugador()
	inicializar_hud()
	inicializar_señales()
	

func reiniciar_pausa():
	pausa = false
	Global.pausar_juego.emit(pausa)
	get_tree().paused = pausa

func inicializar_jugador():
	jugador.vida = 2
	ultima_vida = jugador.vida
	jugador.set_nivel(0)
	jugador.cambiar(Global.arma_elegida)

func inicializar_hud():
	hud.actualizar_hud_vida(jugador.vida, jugador.escudo)
	hud.actualizar_puntuacion_hud(puntos)
	hud.actualizar_combo_hud(combo_actual)
	hud.actualizar_arma_especial(Global.arma_elegida)

func inicializar_señales():
	Global.is_shopping.connect(_on_puede_comprar)
	Global.enemigo_ha_muerto.connect(_on_enemigo_muerto)
	Global.finalizar_victoria.connect(_finalizar_victoria)
	jugador.cooldown_updated.connect(_on_personaje_principal_cooldown_updated)
	jugador.vida_cambiada.connect(_on_actualizar_vida)
	tienda.cambio_nivel.connect(_on_cambio_nivel)
	tienda.cerrar_tienda.connect(_on_cerrar_tienda)
	tienda.cambio_puntos.connect(_on_cambio_puntos)
	tienda.cambio_arma.connect(_on_cambio_arma)
	tienda.compra_vida.connect(_on_compra_vida)
	tienda.compra_escudo.connect(_on_compra_escudo)
	tienda.filtro.connect(_on_filtro)

func _comprobar_estrellas() -> int:
	return 0

func _finalizar_victoria():
	partida_activa = false
	_alterar_pausa()
	if escena_victoria:
		var menu = escena_victoria.instantiate()
		menu.puntos = puntos
		menu.tiempo = tiempo_jugado
		menu.combo = combo_maximo
		var cont = _comprobar_estrellas()
		menu.rellenar_estrellas(cont)
		add_child(menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		print("ERROR: No has asignado la escena de victoria en el Inspector")

func _on_filtro(nombre:String, activo:bool):
	%capa.visible = activo
	%filtro.material.shader = Global.filtros.get(nombre)

func _on_cambio_nivel():
	jugador.mejorar(1)

func _on_compra_vida():
	jugador.curar(1)

func _on_compra_escudo():
	jugador.activar_escudo()

func _on_puede_comprar(puede:bool):
	puede_comprar = puede
	hud.mostrar_aviso_tienda(puede)

func _on_cambio_puntos(nuevos:int):
	puntos = nuevos
	hud.actualizar_puntuacion_hud(nuevos)

func _on_cambio_arma(nueva:String):
	jugador.cambiar(nueva)
	hud.actualizar_arma_especial(nueva)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not pausa:
		tiempo_jugado+=delta
	
	if Input.is_action_just_pressed("pausa") && partida_activa:
		if tienda_abierta:
			_on_cerrar_tienda()
		else:
			print("estoy pausando crack")
			_alterar_pausa()
			get_tree().paused = pausa
			if %menu_pausa.visible:
					%menu_pausa.visible = false
					%menu_opciones.visible = false
			else:
				tienda_abierta = false
				%menu_pausa.visible = true
	if Input.is_action_just_pressed("tienda") && partida_activa && puede_comprar:
		if tienda_abierta:
			_on_cerrar_tienda()
		else:
			_on_enter_shop()

func _on_enemigo_muerto(p : int):
	puntos = puntos + p
	combo_actual = combo_actual+1
	if combo_actual > combo_maximo:
		combo_maximo = combo_actual
	hud.actualizar_combo_hud(combo_actual)
	hud.actualizar_puntuacion_hud(puntos)

func _on_actualizar_vida():
	if jugador.vida < ultima_vida:
		if combo_actual > 1:
			combo_actual = combo_actual-1
			hud.actualizar_combo_hud(combo_actual)
		ultima_vida = jugador.vida
	hud.actualizar_hud_vida(jugador.vida, jugador.escudo)
	if jugador.vida <= 0:
		partida_activa = false
		_alterar_pausa()
		if escena_game_over:
			var menu = escena_game_over.instantiate()
			menu.puntos = puntos
			menu.tiempo = tiempo_jugado
			menu.combo = combo_maximo
			add_child(menu)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			print("ERROR: No has asignado la escena de Game Over en el Inspector")

func _on_personaje_principal_cooldown_updated(time_left: float) -> void:
	hud.actualizar_temp_especial(time_left)

func _alterar_pausa():
	pausa = not pausa
	Global.pausar_juego.emit(pausa)
	get_tree().paused = pausa

func _on_button_pressed() -> void:
	_alterar_pausa()
	%menu_pausa.visible = false
	get_tree().paused = pausa


func _on_timer_1_timeout() -> void:
	%AnimationPlayer2.play("mov_camara_2")
	%timer2.start()


func _on_timer_2_timeout() -> void:
	%AnimationPlayer3.play("mov_camara_3")
	await $%AnimationPlayer3.animation_finished
	$tankboss2/TriggerBoss.monitoring = true

func _on_button_2_pressed() -> void:
	%menu_pausa.visible = false
	%menu_opciones.visible = true


func _on_opciones_back_pressed() -> void:
	%menu_opciones.visible = false
	%menu_pausa.visible = true


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _on_h_slider_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_h_slider_value_changed(value: float) -> void:
	var normalized = value / 255.0
	rect_brillo.color.a = 1.0 - normalized

func _on_button_3_pressed() -> void:
	%menu_opciones.visible = false
	%menu_pausa.visible = false
	_alterar_pausa()
	get_tree().paused = pausa
	get_tree().reload_current_scene()

func _on_cerrar_tienda() -> void:
	tienda_abierta = false
	tienda.visible = false
	_alterar_pausa()
	get_tree().paused = pausa

func _on_enter_shop():
	tienda_abierta = true
	tienda.visible = true
	tienda.set_puntos(puntos)
	tienda.set_arma(jugador.cadEspecial)
	tienda.set_nivel(jugador.get_nivel())
	tienda.set_escudo(jugador.escudo)
	tienda.set_vida(jugador.vida)
	_alterar_pausa()

func _on_button_4_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(ruta_menu_principal)
