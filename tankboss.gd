extends Node3D

@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/playback")

var a = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_tree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if a < 0.1:
		state.travel("walk")
	else:
		state.travel("gira_cabeza")
