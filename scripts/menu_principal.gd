extends Node3D

@onready var rect_brillo = $ColorRectBrillo
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	%camara_menus.position = Vector3(-20.478,11.27,90.358)
	%camara_menus.rotation_degrees = Vector3(-16.6,25.1,4)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	%menu_principal.visible = false 
	%animacion_menu_niveles.play("menu_niveles")
	await get_tree().create_timer(8).timeout
	%menu_niveles.visible = true
	await get_tree().create_timer(0.5).timeout
	%level1_animation.play("level1_anim")

func _on_options_button_pressed() -> void:
	%menu_principal.visible = false
	%animacion_menu_opciones.play("camara_menu_opciones")
	await get_tree().create_timer(4.0).timeout
	%menu_opciones.visible = true


func _on_opciones_back_pressed() -> void:
	%menu_opciones.visible = false 
	%animacion_menu_opciones.play_backwards("camara_menu_opciones")
	await get_tree().create_timer(4.0).timeout
	%menu_principal.visible = true


func _on_level_menu_back_button_pressed() -> void:
	%menu_niveles.visible = false
	%animacion_menu_niveles.play_backwards("menu_niveles")
	await get_tree().create_timer(8.5).timeout
	%menu_principal.visible = true
	

func _on_level_1_pressed() -> void:
	%animl1tol2.play("animl1-to-l2")
	await get_tree().create_timer(2.5).timeout
	%level2_animation.play("level1_anim")
	%level_selected.play("lvl_selected")

func _on_level_2_pressed() -> void:
	%animl2tol3.play("animl1-to-l2")
	await get_tree().create_timer(2.5).timeout
	%level3_animation.play("level1_anim")
	%level_selected2.play("lvl_selected")

func _on_level_3_pressed() -> void:
	%level_selected3.play("lvl_selected")
	
func _on_button_2_pressed() -> void:
	%level_selected.play_backwards("lvl_selected")
	
func _on_button_return_2_pressed() -> void:
	%level_selected2.play_backwards("lvl_selected")
	
func _on_button_2_lvl_3_pressed() -> void:
	%level_selected3.play_backwards("lvl_selected")

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


func _on_h_slider_value_changed(value: float) -> void:
	var normalized = value / 255.0
	rect_brillo.color.a = 1.0 - normalized


func _on_h_slider_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_boton_start_2_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/niveles/nivel2.tscn")


func _on_boton_start_1_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/niveles/nivel1.tscn")


func _on_boton_return_1_pressed() -> void:
	%level_selected.play_backwards("lvl_selected")
