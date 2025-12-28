extends Node3D

var puntuacion : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%puntuacion_datos.text = str(puntuacion)
	
	for anillo : Area3D in %Anillos.get_children():
		anillo.body_entered.connect(_on_anillo_body_entered.bind(anillo))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	for anillo : Area3D in %Anillos.get_children(): 
		anillo.visible = toggled_on

func _on_anillo_body_entered(body: Node3D, emitter: Area3D):
	if emitter.visible:
		puntuacion+=10
		%puntuacion_datos.text = str(puntuacion)
		emitter.queue_free()
		pass
