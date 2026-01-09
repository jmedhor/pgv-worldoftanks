# Nivel_2.gd
extends NivelBase

func _ready():
	nombreNivel = "lvl2"
	super._ready() 
	
	print("Iniciando Nivel 2: Ciudad en ruinas")

func _comprobar_estrellas() -> Array:
	var estrellas = [false,false,false]
	if (puntos > 6500):
		estrellas[0] = true
	if jugador.vida >= 3:
		estrellas[1] = true
	if combo_maximo >= 40:
		estrellas[2] = true
	return estrellas

func _on_timer_2_timeout() -> void:
	%AnimationPlayer3.play("mov_camara_3")
	await $%AnimationPlayer3.animation_finished
	$TriggerBoss.monitoring = true

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
