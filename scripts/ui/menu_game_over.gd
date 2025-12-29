extends Control

@export_file("*.tscn") var ruta_menu_principal
var puntos : int
var combo : int
var tiempo : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LabelFraseRandom.text = obtener_frase_aleatoria()
	%LabelPuntos.text = "Puntuacion: %s" % puntos
	%LabelCombo.text = "Mejor combo: x%s" % combo
	%LabelTiempo.text = "Tiempo: %s" % formatear_tiempo(tiempo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_boton_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()



func _on_boton_volver_pressed() -> void:
	if ruta_menu_principal:
		get_tree().change_scene_to_file(ruta_menu_principal)
	else:
		print("No hay escena de menu principal :(")

func obtener_frase_aleatoria() -> String:
	var lista_frases = [
		"¡Casi lo logras!",
		"La próxima será la buena",
		"¡No te rindas, soldado!",
		"Eso ha tenido que doler...",
		"Inténtalo de nuevo",
		"Has probado a usar las manos crack?",
		"¿Juegas con el monitor apagado?",
		"He visto piedras con mejores reflejos.",
		"El tutorial era para el otro lado.",
		"Esquivas peor que un cono de tráfico.",
		"Más manco y no naces.",
		"¿Te has sentado encima del teclado?",
		"Parece que el mando te queda grande.",
		"Mi abuela en coma dispara mejor.",
		"Pulsa Alt+F4 para dejar de sufrir.",
		"Por favor, desinstala el juego.",
		"¿Quieres que baje la dificultad a 'Bebé'?",
		"Gastaste dinero para morir así...",
		"Error 404: Habilidad no encontrada.",
		"Los desarrolladores se están riendo de ti.",
		"¿Estás jugando tú o tu gato?"
	]
	return lista_frases.pick_random()

func formatear_tiempo(segundos_totales: float) -> String:
	var minutos = int(segundos_totales / 60)
	var segundos = int(segundos_totales) % 60
	
	return "%dm %ds" % [minutos, segundos]
