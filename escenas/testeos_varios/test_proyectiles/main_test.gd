extends Node3D

@export var projectile_scene: PackedScene

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		fire_projectile()

func fire_projectile() -> void:
	var projectile: AreaReactiva = projectile_scene.instantiate()
	projectile.inicializar($PuntoDisparo.position, Vector3(0.0,0.0,-1.0))
	
	add_child(projectile)
