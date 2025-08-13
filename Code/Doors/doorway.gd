extends StaticBody3D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var is_closed: bool = true

func move_door():
	if is_closed:
		open_door()
	else:
		close_door()

func open_door():
	is_closed = false
	animation_player.play("door_open")

func close_door():
	is_closed = true
	animation_player.play("door_close")
