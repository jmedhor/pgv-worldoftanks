# Nivel_2.gd
extends NivelBase

func _ready():
	nombreNivel = "lvl2"
	super._ready() 
	
	print("Iniciando Nivel 2: Ciudad en ruinas")

func _comprobar_estrellas() -> Array:
	var estrellas = [false,false,false]
	if (puntos > 1500):
		estrellas[0] = true
	if jugador.vida >= 2:
		estrellas[1] = true
	if combo_maximo >= 3:
		estrellas[2] = true
	return estrellas
