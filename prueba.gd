extends Node3D

var pausa := false
var timer1 : SceneTreeTimer
var timer2 : SceneTreeTimer
@onready var rect_brillo = $ColorRectBrillo
var dinero : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimationPlayer.play("mov_camara")
	%timer1.start()
	dinero = 100
	%Dinero_tienda.text = str(dinero)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa"): 
		print("estoy pausando crack")
		pausa = not pausa
		get_tree().paused = pausa
		if %menu_pausa.visible:
				%menu_pausa.visible = false
				%menu_opciones.visible = false
		else:
			%menu_pausa.visible = true


func _on_check_button_toggled(toggled_on: bool) -> void:
	print("estoy quitando la pausa crack")
	pausa = not pausa
	get_tree().paused = pausa


func _on_button_pressed() -> void:
	pausa = not pausa
	%menu_pausa.visible = false
	get_tree().paused = pausa


func _on_timer_1_timeout() -> void:
	%AnimationPlayer2.play("mov_camara_2")
	%timer2.start()


func _on_timer_2_timeout() -> void:
	%AnimationPlayer3.play("mov_camara_3")


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
	pausa = not pausa
	get_tree().paused = pausa
	%AnimationPlayer.stop()
	%AnimationPlayer2.stop()
	%AnimationPlayer3.stop()
	%AnimationPlayer.play("mov_camara")
	%timer1.start()


func _on_button_4_pressed() -> void:
	if dinero >= 100:
		dinero = dinero - 100
		%Dinero_tienda.text = str(dinero)
		print("Has comprado puta")
	else:
		print("No tienes dinero para comprar puta")


func _on_cerrar_tienda_pressed() -> void:
	%cerrartienda.play("cerrar_tienda")
	pausa = not pausa
	get_tree().paused = pausa




func _on_colision_tienda_area_body_entered(body: Node3D) -> void:
	if body.name == "tanque" :
		%Tienda.visible = true
		%cerrartienda.play_backwards("cerrar_tienda")
		pausa = not pausa
		get_tree().paused = pausa


func _on_colision_tienda_area_2_body_entered(body: Node3D) -> void:
	if body.name == "tanque" :
		%Tienda.visible = true
		%cerrartienda.play_backwards("cerrar_tienda")
		pausa = not pausa
		get_tree().paused = pausa
