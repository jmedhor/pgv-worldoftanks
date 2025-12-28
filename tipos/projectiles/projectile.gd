class_name Projectile extends Area3D

signal hit(body: Node3D)
signal expire()

@export var data: ProjectileData
var direction: Vector3
var self_remove: bool = true

func _ready() -> void:
	assert(data, "El proyectil debe tener datos asignados.")
	
	collision_layer = data.collision_layer
	collision_mask = data.collision_mask
	connect("body_entered", _on_collision)
	
	for effect in data.effects:
		effect.on_spawn(self)
	
	var notifier := VisibleOnScreenNotifier3D.new()
	
	notifier.aabb = AABB(Vector3(-0.5,-0.5,-0.5), Vector3.ONE)
	notifier.connect("screen_exited", _on_screen_exit)
	add_child(notifier)

func _physics_process(delta: float) -> void:
	position += (direction * data.speed * delta)
	
	for effect in data.effects:
		effect.on_update(self, delta)

func _on_collision(body: Node3D) -> void:
	emit_signal("hit", body)
	
	for effect in data.effects:
		effect.on_hit(self, body)
	
	if self_remove:
		queue_free()

func _on_screen_exit() -> void:
	emit_signal("expire")
	
	for effect in data.effects:
		effect.on_expire(self)
	
	queue_free()

func shoot(pos: Vector3, dir: Vector3) -> void:
	position = pos if pos != null else Vector3.ZERO
	direction = dir.normalized() if dir != null else Vector3.ZERO

func play_vfx() -> void:
	if data.vfx_scene:
		var vfx = data.vfx_scene.instantiate()
	
		get_tree().current_scene.add_child(vfx)
		vfx.global_position = global_position
