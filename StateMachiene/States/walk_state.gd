extends LimboState


func _enter() -> void:
	print("walking")

func _update(delta: float) -> void:
	if agent.play_direction == Vector3.ZERO:
		get_root().dispatch("to_idle")
	if agent.is_sprinting and agent.can_sprint:
		get_root().dispatch("to_sprint")
