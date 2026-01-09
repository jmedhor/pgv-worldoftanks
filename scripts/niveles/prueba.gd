# Nivel_1.gd
extends NivelBase

func _ready():
	# 'super._ready()' ejecuta el código del padre (el bloque que querías)
	nombreNivel = "lvl1"
	super._ready() 
	# Aquí puedes añadir cosas ÚNICAS del Nivel 1
	print("Iniciando Nivel 1: El bosque")
	print("Datos $s", datosNivel)
	

func _comprobar_estrellas() -> Array:
	var estrellas = [false,false,false]
	if (puntos > 4000):
		estrellas[0] = true
	if jugador.vida >= 2:
		estrellas[1] = true
	if combo_maximo >= 25:
		estrellas[2] = true
	return estrellas

func barrera_delantera(body):
	if body.has_method("activar_enemigo"):
		body.activar_enemigo()
		
func barrera_trasera(body):
	if body.has_method("eliminar_borde"):
		body.eliminar_borde()

func proyectil_trasero(area):
	if area.has_method("_on_salida_pantalla"):
		area._on_salida_pantalla()
		
func proyectil_delantero(area):
	if area.has_method("_on_salida_pantalla"):
		area._on_salida_pantalla()
