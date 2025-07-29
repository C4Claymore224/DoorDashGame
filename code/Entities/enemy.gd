extends CharacterBody3D
class_name Enemy

@export var type: Enem_Type

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var confused_timer: Timer = $"confused timer"

var target : Player
var direction

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	# We sense the player
	if target:
		follow_target()
		look_at(target.global_position) # look at him
		var distance = global_position.distance_to(target.global_position)
		if distance <= type.attack_range:
			attack()
		if distance >= 25:
			wonder_around()
	else:
		pass
	
	if not is_on_floor():
		velocity.y -= 9.2 * delta
	else:
		velocity.y -= 2
	
	
	## keep for later maybe :V
	#velocity.y = JUMP_VELOCITY
	#if direction:
		#velocity.x = direction.x * type.speed
		#velocity.z = direction.z * type.speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, type.speed)
		#velocity.z = move_toward(velocity.z, 0, type.speed)

	move_and_slide()


func _on_detection_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body

# follow target
func follow_target() -> void:
	navigation_agent_3d.set_target_position(target.global_position) # chase player with navigation
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_transform.origin
	var nav_direction = local_destination.normalized()
	velocity = nav_direction * type.speed
	 
func attack():
	print("attacking")

# the stoping of the chase
func wonder_around():
	print("not a player in sight")
