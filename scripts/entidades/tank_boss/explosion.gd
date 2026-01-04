extends Node3D

@export var damage := 10
@onready var sprite := $AnimatedSprite3D
@onready var area := $Area3D
@onready var fire = $Fire
@onready var Debris = $Debris
@onready var Smoke = $Smoke

func _ready():
	$AudioStreamPlayer3D.play()
	fire.emitting = true
	Debris.emitting = true
	Smoke.emitting = true
	area.monitoring = true
	area.body_entered.connect(_on_Area3D_body_entered)
	
	
	await get_tree().create_timer(fire.lifetime).timeout
	area.monitoring = false
	await get_tree().create_timer(Debris.lifetime).timeout
	
	await get_tree().create_timer(Smoke.lifetime).timeout
	
	
	
	queue_free()
	
	
	

func _on_Area3D_body_entered(body):
	if body.name == "Personaje_principal":
		
		
		body.recibir_dano(damage)
		
