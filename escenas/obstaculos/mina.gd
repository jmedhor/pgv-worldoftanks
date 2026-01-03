extends AreaReactiva

@export var dano := 1
@export var destruir_al_explotar := true
@export var delay_explosion := 0.0   # 0 = instantánea

var activada := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Evitar que explote varias veces
	if activada:
		return

	# Comprobamos que es el jugador
	if body.has_method("recibir_dano") and body.vivo:
		activada = true

		if delay_explosion > 0:
			await get_tree().create_timer(delay_explosion).timeout

		explotar(body)

func explotar(jugador):
	# Sonido / partículas
	reproducir_vfx();
	# Daño real al jugador
	jugador.recibir_dano(dano)

	# Desactivar colisión para no repetir daño
	monitoring = false
	monitorable = false

	# Eliminar la mina
	if destruir_al_explotar:
		queue_free()
