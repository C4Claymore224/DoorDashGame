extends LimboState


func _enter() -> void:
	print("idle State")

func _update(delta: float) -> void:
	if agent.play_direction != Vector3.ZERO:
		get_root().dispatch("to_walk")
