extends Node3D

@onready var restos: GPUParticles3D = $Restos
@onready var humo: GPUParticles3D = $Humo
@onready var fuego: GPUParticles3D = $Fuego
@onready var sonido_explosion: AudioStreamPlayer3D = $SonidoExplosion

func _ready() -> void:
	restos.emitting = true
	humo.emitting = true
	fuego.emitting = true
	sonido_explosion.play()
	
	await get_tree().create_timer(2.0).timeout
	queue_free()
