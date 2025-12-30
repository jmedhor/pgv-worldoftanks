extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func camera_shake_simple(intensity := 0.15, time := 0.3):
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		original_pos + Vector3(intensity, 0, 0),
		time * 0.25
	)
	tween.tween_property(
		self,
		"position",
		original_pos + Vector3(-intensity, 0, 0),
		time * 0.25
	)
	tween.tween_property(
		self,
		"position",
		original_pos,
		time * 0.5
	)
