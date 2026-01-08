extends Node

var datos_jugador = {
	"levels": {
		"lvl1": {"completado":false, "obj1": false, "obj2": false, "obj3": false, "best_score":0},
		"lvl2": {"completado":false, "obj1": false, "obj2": false, "obj3": false, "best_score":0},
		"lvl3": {"completado":false, "obj1": false, "obj2": false, "obj3": false, "best_score":0}
	},
	"last_special":"dmg"
}

var configuracion = {
	"sonido":75,
	"modoPantalla":0,
	"borderless": false,
	"brillo":1.0
}

func is_lvl_completed(nivel:String):
	return datos_jugador.get("levels").get(nivel).get("completado")

func get_level(nivel:String):
	return datos_jugador.get("levels").get(nivel)

func get_last_special():
	return datos_jugador.get("last_special")

func set_last_special(especial:String):
	datos_jugador.set("last_special", especial)
	
func set_level(nivel:String, datos:Dictionary):
	datos_jugador.get("levels").set(nivel, datos)

func update_level(nivel:String, completo: bool, obj1: bool, obj2:bool, obj3:bool, puntos: int):
	if not datos_jugador.get("levels").get(nivel).get("completado"):
		datos_jugador.get("levels").get(nivel).set("completado", completo)
	if not datos_jugador.get("levels").get(nivel).get("obj1"):
		datos_jugador.get("levels").get(nivel).set("obj1", obj1)
	if not datos_jugador.get("levels").get(nivel).get("obj2"):
		datos_jugador.get("levels").get(nivel).set("obj2", obj2)
	if not datos_jugador.get("levels").get(nivel).get("obj3"):
		datos_jugador.get("levels").get(nivel).set("obj3", obj3)
	if datos_jugador.get("levels").get(nivel).get("best_score") < puntos:
		datos_jugador.get("levels").get(nivel).set("best_score", puntos)

func guardar_datos():
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(datos_jugador)
	file.store_line(json_string)

func guardar_config():
	var file = FileAccess.open("user://config.save", FileAccess.WRITE)
	var json_string = JSON.stringify(configuracion)
	file.store_line(json_string)

func cargar_datos():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json = JSON.new()
		json.parse(file.get_line())
		datos_jugador = json.data

func cargar_config():
	if FileAccess.file_exists("user://config.save"):
		var file = FileAccess.open("user://config.save", FileAccess.READ)
		var json = JSON.new()
		json.parse(file.get_line())
		configuracion = json.data
