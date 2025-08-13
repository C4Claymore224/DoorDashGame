extends Node3D
class_name Projectile

# FIXME: BULLET CALLING DAMAGE FUNC 5 TIMES

@export var speed: int
@export var damage: int

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,0, -speed) * delta
	if ray_cast_3d.is_colliding():
		#mesh_instance_3d.visible = false
		#gpu_particles_3d.emitting = true
		var target = ray_cast_3d.get_collider()
		if target.has_method("attack_player"): # Enemy method
			target.take_damage(damage)
			queue_free()

func _on_despawn_timeout() -> void:
	queue_free()
	print("don")
