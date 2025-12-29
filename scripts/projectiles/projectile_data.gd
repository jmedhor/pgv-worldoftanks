class_name ProjectileData extends Resource

@export var speed: float = 0.0
@export var effects: Array[ProjectileEffect] = []

@export_flags_3d_physics var collision_layer: int = 1
@export_flags_3d_physics var collision_mask: int = 1

@export var vfx_scene: PackedScene
