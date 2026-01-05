# Nivel_1.gd
extends NivelBase

func _ready():
	# 'super._ready()' ejecuta el código del padre (el bloque que querías)
	super._ready() 
	
	# Aquí puedes añadir cosas ÚNICAS del Nivel 1
	print("Iniciando Nivel 1: El bosque")

func _comprobar_estrellas() -> int:
	var cont = 0
	if (puntos > 1500):
		cont+=1
	if jugador.vida >= 2:
		cont+=1
	if combo_maximo >= 3:
		cont+=1
	return cont
