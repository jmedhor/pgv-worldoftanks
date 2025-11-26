extends Node3D

var pausa := false
var timer1 : SceneTreeTimer
var timer2 : SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimationPlayer.play("mov_camara")
	%timer1.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pausa"): 
		print("estoy pausando crack")
		pausa = not pausa
		get_tree().paused = pausa
		if %menu_pausa.visible:
				%menu_pausa.visible = false
		else:
			%menu_pausa.visible = true


func _on_check_button_toggled(toggled_on: bool) -> void:
	print("estoy quitando la pausa crack")
	pausa = not pausa
	get_tree().paused = pausa


func _on_button_pressed() -> void:
	pausa = not pausa
	%menu_pausa.visible = false
	get_tree().paused = pausa


func _on_timer_1_timeout() -> void:
	%AnimationPlayer2.play("mov_camara_2")
	%timer2.start()


func _on_timer_2_timeout() -> void:
	%AnimationPlayer3.play("mov_camara_3")
