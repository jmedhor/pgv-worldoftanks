class_name DamageEffect extends ProjectileEffect

@export var damage: float = 0.0

func on_hit(_obj: Projectile, body: Node3D) -> void:
	_apply_damage(damage, body)
