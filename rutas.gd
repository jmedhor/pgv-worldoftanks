extends Node3D
@export var enemy_path_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ruta in $".".get_children():
		for path_follow : PathFollow3D in ruta.get_children():
			var previous_progress = path_follow.progress
			
			path_follow.progress += 2.0 * delta
			
			if previous_progress > path_follow.progress:
				for enemy in path_follow.get_children():
					enemy.queue_free()
				path_follow.queue_free()


func _on_temporizador_timeout() -> void:
	var enemy_path = enemy_path_scene.instantiate()
	var path_follow = PathFollow3D.new()
	
	path_follow.add_child(enemy_path)
	
	$Primera/PathFollow3D.add_child(path_follow)


func _on_area_3d_area_entered(area: Area3D) -> void:
	pass
