extends Node3D

@export var test_max_enemigos : float = 5.0
@export var tiempoSpawn : float = 5.0
@export var enemigo:PackedScene
@export var enemigoPos : float = 10.0

var enemigos : Array

var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerSpawn.start(tiempoSpawn) # Replace with function body.
	rng = RandomNumberGenerator.new()
	
func _on_timer_spawn_timeout():
	for enem in enemigos:
		if enem == null:
			enemigos.erase(enem)
	if enemigos.size() < test_max_enemigos and self.visible:
		var nu_enemigo = enemigo.instantiate()
		nu_enemigo.position = self.position + Vector3(enemigoPos - (enemigoPos*2*rng.randf()), 0,0)
		add_sibling(nu_enemigo)
		
		enemigos.append(nu_enemigo)
		
	$TimerSpawn.start(tiempoSpawn)
	print(enemigos.size())
