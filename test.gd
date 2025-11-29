extends Node3D

@onready var jugador = $Personaje_principal
@onready var hud = $hud
@export var escena_game_over : PackedScene
var tiempo_jugado : float = 0
var puntos : int = 0
var partida_activa : bool = true
var combo_maximo : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.actualizar_hud_vida(jugador.vida)
	hud.actualizar_puntuacion_hud(0)
	hud.actualizar_combo_hud(1)
	jugador.vida_cambiada.connect(hud.actualizar_hud_vida)
	jugador.he_muerto.connect(_on_jugador_muerto)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if partida_activa:
		tiempo_jugado += delta
	
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
