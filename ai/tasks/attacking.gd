extends BTAction

func _tick(_delta: float) -> Status:
	if agent.in_range_to_attack:
		agent.attack_player()
		return SUCCESS
	else:
		agent.bt_player.blackboard.set_var("State", "persue")
		agent.bt_player.restart()
		return SUCCESS
