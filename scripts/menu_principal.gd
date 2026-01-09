extends Node3D

@onready var rect_brillo = $ColorRectBrillo

var level2unlocked
var level3unlocked

func _ready() -> void:
	%camara_menus.position = Vector3(-20.478,11.27,90.358)
	%camara_menus.rotation_degrees = Vector3(-16.6,25.1,4)
	SaveManager.cargar_datos()
	SaveManager.cargar_config()
	print(SaveManager.datos_jugador)
	print(SaveManager.configuracion)
	set_brillo()
	set_modo()
	set_sonido()
	%menu_nivel_selected4.set_especial(SaveManager.get_last_special())
	level2unlocked = SaveManager.is_lvl_completed("lvl1")
	level3unlocked = SaveManager.is_lvl_completed("lvl2")

func _on_start_button_pressed() -> void:
	level2unlocked = SaveManager.is_lvl_completed("lvl1")
	level3unlocked = SaveManager.is_lvl_completed("lvl2")
	
	%menu_principal.visible = false 
	
	%animacion_menu_niveles.play("menu_niveles")
	await get_tree().create_timer(8).timeout
	%menu_niveles.visible = true
	
	await get_tree().create_timer(0.5).timeout
	%level1_animation.play("level1_anim")
	
	if level2unlocked:
		%animl1tol2.play("animl1-to-l2")
		await get_tree().create_timer(2.5).timeout
		%level2_animation.play("level2_anim")
	if level3unlocked:
		%animl2tol3.play("animl1-to-l2")
		await get_tree().create_timer(2.5).timeout
		%level3_animation.play("level3_anim")

func _on_options_button_pressed() -> void:
	%menu_principal.visible = false
	%animacion_menu_opciones.play("camara_menu_opciones")
	await get_tree().create_timer(4.0).timeout
	%menu_opciones.visible = true

func _on_opciones_back_pressed() -> void:
	SaveManager.guardar_config()
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
	var nivel = SaveManager.get_level("lvl1")
	var objetivos = [
		{"cadena": "Consigue mas de 4000 puntos", "completo":nivel.get("obj1")},
		{"cadena": "Acaba con 2 o mas vidas", "completo":nivel.get("obj2")},
		{"cadena": "Consigue un combo minimo de x25", "completo":nivel.get("obj3")}
	]
	%menu_nivel_selected4.pasar_nivel("El bosque", objetivos, "res://escenas/niveles/nivel1.tscn")
	%menu_nivel_selected4.play()

func _on_level_2_pressed() -> void:
	var nivel = SaveManager.get_level("lvl2")
	var objetivos = [
		{"cadena": "Consigue mas de 6500 puntos", "completo":nivel.get("obj1")},
		{"cadena": "Acaba con 3 o mas vidas", "completo":nivel.get("obj2")},
		{"cadena": "Consigue un combo minimo de x40", "completo":nivel.get("obj3")}
	]
	%menu_nivel_selected4.pasar_nivel("Ciudad en ruinas", objetivos, "res://escenas/niveles/nivel2.tscn")
	%menu_nivel_selected4.play()

func _on_level_3_pressed() -> void:
	var nivel = SaveManager.get_level("lvl3")
	var objetivos = [
		{"cadena": "Consigue mas de 9000 puntos", "completo":nivel.get("obj1")},
		{"cadena": "Acaba con 4", "completo":nivel.get("obj2")},
		{"cadena": "Consigue un combo minimo de x65", "completo":nivel.get("obj3")}
	]
	%menu_nivel_selected4.pasar_nivel("El desierto", objetivos, "res://escenas/niveles/nivel3.tscn")
	%menu_nivel_selected4.play()
	
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
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	SaveManager.configuracion.set("modoPantalla",index)

func _on_h_slider_value_changed(value: float) -> void:
	var normalized = value / 255.0
	rect_brillo.color.a = 1.0 - normalized
	SaveManager.configuracion.set("brillo", value)

func _on_h_slider_2_value_changed(value: float) -> void:
	var valor_lineal = value / 100.0
	var db = linear_to_db(valor_lineal)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	SaveManager.configuracion.set("sonido", value)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_boton_start_2_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/niveles/nivel2.tscn")

func _on_boton_start_1_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/niveles/nivel1.tscn")

func _on_boton_return_1_pressed() -> void:
	%level_selected.play_backwards("lvl_selected")

func set_brillo():
	var value = SaveManager.configuracion.get("brillo")
	var normalized = value / 255.0
	rect_brillo.color.a = 1.0 - normalized
	%HSlider.value = value

func set_sonido():
	var value = SaveManager.configuracion.get("sonido")
	var valor_lineal = value / 100.0
	var db = linear_to_db(valor_lineal)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	%HSlider2.value = value

func set_modo():
	await get_tree().process_frame
	var index = int(SaveManager.configuracion.get("modoPantalla"))
	%OptionButton.selected = index
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
