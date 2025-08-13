extends LimboState


func _enter() -> void:
	pass

func _update(_delta: float) -> void:
	if agent.velocity.y == 0:
		get_root().dispatch("to_idle")
