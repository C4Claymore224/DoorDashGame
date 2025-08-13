extends LimboState


func _enter() -> void:
	pass

func _update(_delta: float) -> void:
	if agent.play_direction != Vector3.ZERO:
		get_root().dispatch("to_walk")
	if agent.velocity.y > 0:
		get_root().dispatch("to_jump")
	if agent.velocity.y < 0:
		get_root().dispatch("to_fall")
		
