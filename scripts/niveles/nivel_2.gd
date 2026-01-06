# Nivel_2.gd
extends NivelBase

func _ready():
	super._ready() 
	
	print("Iniciando Nivel 2: Ciudad en ruinas")

func _comprobar_estrellas() -> int:
	var cont = 0
	if (puntos > 1500):
		cont+=1
	if jugador.vida >= 2:
		cont+=1
	if combo_maximo >= 3:
		cont+=1
	return cont
