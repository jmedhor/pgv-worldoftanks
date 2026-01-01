extends Node3D

@onready var jugador = $Personaje_principal
@onready var hud = $hud
@export var escena_game_over : PackedScene
var tiempo_jugado : float = 0
var puntos : int = 0
var partida_activa : bool = true
var ultima_vida : int
var combo_maximo : int
var combo_actual : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ultima_vida = jugador.vida
	combo_actual = 10
	combo_maximo = combo_actual
	hud.actualizar_hud_vida(jugador.vida)
	hud.actualizar_puntuacion_hud(puntos)
	hud.actualizar_combo_hud(combo_actual)
	jugador.vida_cambiada.connect(_on_actualizar_vida)
	jugador.he_muerto.connect(_on_jugador_muerto)
	Global.enemigo_ha_muerto.connect(_on_enemigo_muerto)
	jugador.cambiar("emp")
	hud.actualizar_arma_especial("emp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if partida_activa:
		tiempo_jugado += delta

func _on_enemigo_muerto(p : int):
	puntos = puntos + p
	combo_actual = combo_actual+1
	if combo_actual > combo_maximo:
		combo_maximo = combo_actual
	hud.actualizar_combo_hud(combo_actual)
	hud.actualizar_puntuacion_hud(puntos)

func _on_actualizar_vida(vida : int):
	if jugador.vida < ultima_vida:
		combo_actual = combo_actual-1
		ultima_vida = jugador.vida
		hud.actualizar_combo_hud(combo_actual)
	hud.actualizar_hud_vida(vida)

func _on_jugador_muerto():
	partida_activa = false
	if escena_game_over:
		var menu = escena_game_over.instantiate()
		menu.puntos = puntos
		menu.tiempo = tiempo_jugado
		menu.combo = combo_maximo
		add_child(menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		print("ERROR: No has asignado la escena de Game Over en el Inspector")


func _on_personaje_principal_cooldown_updated(time_left: float) -> void:
	hud.actualizar_temp_especial(time_left)
