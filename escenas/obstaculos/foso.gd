extends AreaReactiva

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# El foso nunca debe autodestruirse
	monitoring = true
	monitorable = true

func _on_body_entered(body):
	if body.has_method("recibir_dano") and body.vivo:
		# Muerte instantánea
		reproducir_vfx();
		body.recibir_dano(10)
