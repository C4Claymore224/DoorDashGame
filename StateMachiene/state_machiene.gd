extends Node

@export var player: Player

var main_sm: LimboHSM

func _ready() -> void:
	initiate_state_machiene()

func initiate_state_machiene():
	main_sm = LimboHSM.new()
	add_child(main_sm)
	
	# makes a new state. calles it idle. when we first enter the state only once. every frame im in the state
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var moving_state = LimboState.new().named("moving").call_on_enter(move_start).call_on_update(move_update)
	var attack_state = LimboState.new().named("attack").call_on_enter(attack_start).call_on_update(attack_update)
	#var jump_state = LimboState.new().named("attack").call_on_enter(attack_start()).call_on_update(attack_update())
	
	main_sm.add_child(idle_state)
	main_sm.add_child(moving_state)
	main_sm.add_child(attack_state)
	
	main_sm.initial_state = idle_state
	
	main_sm.add_transition(idle_state,moving_state,&"to_walk")
	main_sm.add_transition(main_sm.ANYSTATE,idle_state, &"state_ended")
	
	main_sm.initialize(self)
	main_sm.set_active(true)

func idle_start():
	pass

func idle_update(delta: float):
	if player.velocity.x != 0:
		print(player.velocity.z)
		main_sm.dispatch(&"to_walk")

func move_start():
	pass
	
func move_update():
	if player.velocity.x == 0:
		main_sm.dispatch(&"state_ended")

func attack_start():
	pass

func attack_update():
	pass
