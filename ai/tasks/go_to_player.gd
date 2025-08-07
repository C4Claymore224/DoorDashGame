extends BTAction

func _tick(delta: float) -> Status:
	agent.follow_target()
	return RUNNING
