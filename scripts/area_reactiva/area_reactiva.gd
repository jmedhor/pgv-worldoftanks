class_name AreaReactiva extends Area3D

signal golpe(body: Node3D)
signal expira()

@export var datos: Resource
var direccion: Vector3
var auto_destruir: bool = true

func _configurar_colisiones() -> void:
	collision_layer = datos.collision_layer
	collision_mask = datos.collision_mask
	connect("body_entered", _on_colision)

func _configurar_screen_notifier() -> void:
	var notificador := VisibleOnScreenNotifier3D.new()
	
	notificador.aabb = AABB(Vector3(-0.5,-0.5,-0.5), Vector3.ONE)
	notificador.screen_exited.connect(_on_salida_pantalla)
	add_child(notificador)

func _on_salida_pantalla() -> void:
	for efe in datos.efectos:
		efe._on_expired(self)
	
	destruir()

func destruir() -> void:
	emit_signal("expira")
	queue_free()

func _on_colision(body: Node3D) -> void:
	emit_signal("golpe", body)
	
	for efe in datos.efectos:
		efe._on_hit(self, body)
	
	if auto_destruir:
		destruir()

func inicializar(pos: Vector3, dir: Vector3) -> void:
	position = pos if pos != null else Vector3.ZERO
	direccion = dir if dir != null else Vector3.ZERO
	
	if direccion != Vector3.ZERO:
		look_at_from_position(position, position + direccion)

func reproducir_vfx() -> void:
	if datos.escena_vfx:
		var escena = datos.escena_vfx.instantiate()
		
		get_tree().current_scene.add_child(escena)
		escena.global_position = global_position


func _ready() -> void:
	assert(datos, "No puede existir un AreaReactiva sin datos.")
	
	_configurar_colisiones()
	
	if not datos.persistente:
		_configurar_screen_notifier()
	
	for efe in datos.efectos:
		efe._on_spawn(self)

func _physics_process(delta: float) -> void:
	position += (direccion * datos.velocidad * delta)
	
	for efe in datos.efectos:
		efe._on_update(self)
