extends BTAction

func _tick(delta: float) -> Status:
	var target_pos: Vector3 = blackboard.get_var("pos")
	var current_pos : Vector3 = agent.global_transform.origin
	agent.idle_wonder(target_pos, delta)
	
	if Vector2(current_pos.x, current_pos.z).distance_to(Vector2(target_pos.x, target_pos.z)) <= 0.1:
		agent.velocity = Vector3.ZERO
		return SUCCESS
	
	return RUNNING
