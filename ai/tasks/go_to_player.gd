extends BTAction

func _tick(_delta: float) -> Status:
	agent.follow_target()
	
	if agent.in_range_to_attack:
		agent.bt_player.blackboard.set_var("State", "attacking")
		agent.velocity = Vector3.ZERO
		agent.bt_player.restart()
		return SUCCESS
		
	return RUNNING
