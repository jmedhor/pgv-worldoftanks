extends Node3D
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
