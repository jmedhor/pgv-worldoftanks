extends Node3D

var pausa := false
var timer1 : SceneTreeTimer
var timer2 : SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimationPlayer.play("mov_camara")
	timer1 = get_tree().create_timer(90.5)  
	await timer1.timeout
	%AnimationPlayer2.play("mov_camara_2")
	timer2 = get_tree().create_timer(70.5)  
	await timer2.timeout
	%AnimationPlayer3.play("mov_camara_3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa"): 
		print("estoy pausando crack")
		pausa = not pausa
		get_tree().paused = pausa


func _on_check_button_toggled(toggled_on: bool) -> void:
	print("estoy quitando la pausa crack")
	pausa = not pausa
	get_tree().paused = pausa
