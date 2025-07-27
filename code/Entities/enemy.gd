extends CharacterBody3D
class_name Enemy


@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var SPEED : float = 5.0
var JUMP_VELOCITY :float  = 4.5
var gravity: float = 9.2

var target : Player
var direction

func _physics_process(delta: float) -> void:
	if target:
		look_at(target.global_position)
		direction = target.global_position - global_position
		velocity = direction.normalized() * SPEED
	else:
		pass
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
		
	#velocity.y = JUMP_VELOCITY
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_detection_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body

func follow_player() -> void:
	direction = target.global_position - global_position
	var NewSpeed = direction.normalized() * SPEED
	velocity = NewSpeed
	look_at(direction)

func wonder_around():
	pass
