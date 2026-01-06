extends Camera3D

var original_pos: Vector3
var shaking := false

func _ready():
	original_pos = position

func camera_shake(intensity := 0.55, duration := 5.0):
	if shaking:
		return

	shaking = true
	original_pos = position

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)

	var steps := int(duration * 30) # 30 sacudidas por segundo

	for i in range(steps):
		var offset := Vector3(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity),
			0
		)
		tween.tween_property(
			self,
			"position",
			original_pos + offset,
			duration / steps
		)

	
	tween.tween_property(self, "position", original_pos, 0.15)
	tween.finished.connect(_shake_finished)

func _shake_finished():
	position = original_pos
	shaking = false
