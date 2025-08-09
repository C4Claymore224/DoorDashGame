extends LimboState


func _enter() -> void:
	print("sprinting")

func _update(delta: float) -> void:
	if !agent.is_sprinting  and agent.play_direction == Vector3.ZERO:
		get_root().dispatch("to_idle")
	if !agent.is_sprinting  and agent.play_direction != Vector3.ZERO:
		get_root().dispatch("to_walk")
