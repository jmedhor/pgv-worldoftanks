class_name DatosArea extends Resource

@export var velocidad: float = 0.0
@export var persistente: bool = false
@export var efectos: Array[EfectoReactivo] = []

@export_flags_3d_physics var collision_layer: int = 1
@export_flags_3d_physics var collision_mask: int = 1

@export var escena_vfx: PackedScene
