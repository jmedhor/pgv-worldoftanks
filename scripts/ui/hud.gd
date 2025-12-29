extends Control

@onready var barra_vida = %BarraVida
@onready var retrato_estado = %RetratoEstado
@onready var label_puntos = %LabelPuntos
@onready var label_combo = %LabelCombo

@export var textura_100 : Texture2D
@export var textura_75 : Texture2D
@export var textura_50 : Texture2D
@export var textura_25 : Texture2D
@export var textura_0 : Texture2D

@export var barra_4 : Texture2D
@export var barra_3 : Texture2D
@export var barra_2 : Texture2D
@export var barra_1 : Texture2D
@export var barra_0 : Texture2D

func actualizar_hud_vida(vida_actual: int):
	actualizar_imagen_vida(vida_actual)
	actualizar_imagen_retrato(vida_actual)

func actualizar_puntuacion_hud(puntos_nuevos: int):
	label_puntos.text = "%d" % puntos_nuevos

func actualizar_combo_hud(combo: int):
	if combo > 3:
		label_combo.text = "x%d !!!!" % combo
	else:
		label_combo.text = "x%d" % combo

func actualizar_imagen_vida(vida_actual: int):
	if vida_actual == 4: 
		barra_vida.texture = barra_4
	elif vida_actual == 3:
		barra_vida.texture = barra_3
	elif vida_actual == 2:
		barra_vida.texture = barra_2
	elif vida_actual == 1:
		barra_vida.texture = barra_1
	else:
		barra_vida.texture = barra_0

func actualizar_imagen_retrato(vida_actual: int):	
	if vida_actual == 4: 
		retrato_estado.texture = textura_100
	elif vida_actual == 3:
		retrato_estado.texture = textura_75
	elif vida_actual == 2:
		retrato_estado.texture = textura_50
	elif vida_actual == 1:
		retrato_estado.texture = textura_25
	else:
		retrato_estado.texture = textura_0

func actualizar_temp_especial(tiempo: float):
	var barra = $PanelDerecho/MarginContainer/VBoxContainer/Especial/VBoxContainer/ProgressBar
	barra.value = tiempo
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var barra = $PanelDerecho/MarginContainer/VBoxContainer/Especial/VBoxContainer/ProgressBar
	barra.value = 100;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
