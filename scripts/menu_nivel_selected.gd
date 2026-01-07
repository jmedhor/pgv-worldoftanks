extends Control

var escena : String
var estrella = preload("res://assets/icons/star.tres")
var vacio = preload("res://assets/icons/empty_star.tres")
var elegida = 0

var catalogo_strings = [
	"dmg",
	"emp",
]

var catalogo_iconos = [
	preload("res://assets/icons/dmg.png"),
	preload("res://assets/icons/emp.png")
]

func _on_boton_siguiente_arma_pressed() -> void:
	elegida = posmod(elegida + 1, catalogo_strings.size())
	%iconoArma.texture = catalogo_iconos.get(elegida)

func _ready() -> void:
	self.visible = false


func _on_boton_anterior_arma_pressed() -> void:
	elegida = posmod(elegida - 1, catalogo_strings.size())
	%iconoArma.texture = catalogo_iconos.get(elegida)


func _on_boton_start_pressed() -> void:
	Global.arma_elegida = catalogo_strings[elegida]
	get_tree().change_scene_to_file(escena)

func play():
	self.visible = true
	$AnimationPlayer.play("open_menu")

func _on_boton_return_pressed() -> void:
	$AnimationPlayer.play_backwards("open_menu")
	await get_tree().create_timer(1).timeout
	self.visible = false

func pasar_nivel(nombre : String, objetivos : Array, ruta : String):
	%LabelNombre.text = nombre
	%LabelObj1.text = objetivos[0].get("cadena")
	%LabelObj2.text = objetivos[1].get("cadena")
	%LabelObj3.text = objetivos[2].get("cadena")

	%IconoObj1.texture = estrella if objetivos[0].get("completo") else vacio
	%IconoObj2.texture = estrella if objetivos[1].get("completo") else vacio
	%IconoObj3.texture = estrella if objetivos[2].get("completo") else vacio
	escena = ruta
