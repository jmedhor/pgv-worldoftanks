extends Control

var ruta_menu_principal = preload("res://escenas/menu_principal/menu_principal.tscn")
var puntos : int
var combo : int
var tiempo : float
var estrella = preload("res://assets/icons/star.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LabelFraseRandom.text = obtener_frase_aleatoria()
	%LabelPuntos.text = str(puntos)
	%LabelCombo.text = "x%s" % combo
	%LabelTiempo.text = formatear_tiempo(tiempo)

func _on_boton_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()

func rellenar_estrellas(activas:int):
	var texturas = [
		%e1, 
		%e2, 
		%e3
	]

	for i in range(activas):
		texturas[i].texture = estrella
		

func _on_boton_volver_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(ruta_menu_principal)

func obtener_frase_aleatoria() -> String:
	var lista_frases = [
		"¡Victoria magistral!",
		"Demasiado fácil para ti.",
		"¡Eres una auténtica leyenda!",
		"Ni sudaste, ¿verdad?",
		"Nivel completado con estilo.",
		"¿Te has pasado el juego o el juego se ha pasado a ti?",
		"Tus reflejos son de otro planeta.",
		"He visto jugadas buenas, pero esta ha sido épica.",
		"¿Seguro que no eres un speedrunner?",
		"Los desarrolladores están llorando por lo fácil que lo hiciste.",
		"¡Qué clase, qué técnica, qué bárbaro!",
		"El jefe final está pidiendo clemencia.",
		"Ponlo en difícil, que esto te queda pequeño.",
		"Haces que parezca un paseo por el parque.",
		"Directo al salón de la fama.",
		"Habilidad máxima desbloqueada.",
		"Ni el lag pudo detenerte.",
		"¿Eso que escucho son aplausos? Ah no, es el motor explotando de tu velocidad.",
		"MVP absoluto de la partida.",
		"Veni, vidi, vici. ¡A por el siguiente!",
		"Tus manos son de oro, crack."
	]
	return lista_frases.pick_random()

func formatear_tiempo(segundos_totales: float) -> String:
	var minutos = int(segundos_totales / 60)
	var segundos = int(segundos_totales) % 60
	
	return "%dm %ds" % [minutos, segundos]
