extends Node

signal enemigo_ha_muerto(puntos)
signal pausar_juego(pausa:bool)
signal is_shopping(puede:bool)
signal finalizar_victoria()

const MAX_NIVEL_JUGADOR: int = 2
const MAX_VIDA_JUGADOR: int = 4

var arma_elegida : String
var filtros = {"byn" : preload("res://assets/byn.gdshader"), "nv" : preload("res://assets/nv.gdshader"), "crt": preload("res://assets/crt.gdshader")}
