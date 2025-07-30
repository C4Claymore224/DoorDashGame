extends CharacterBody3D
class_name Enemy

enum State {
	IDLE,
	CHASING,
	ATTACKING
}
var current_state: State = State.IDLE

@export var type: Enem_Type

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var confused_timer: Timer = $"confused timer"
@onready var sight: RayCast3D = $Sight

var target : Player
var direction
var seeing_player: bool = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	match current_state:
		pass
	
	# We sense the player
	if target:
		look_at(target.global_position) # look at him
		var distance = global_position.distance_to(target.global_position)
		if distance >= type.stop_persuit:
			stop()
		if distance <= type.attack_range:
			attack()
		if seeing_player:
			follow_target()
	else:
		stop()
		
	if sight.is_colliding():
		var sight_body = sight.get_collider()
		if !sight_body.has_method("_head_bob"): # if body is player
			seeing_player = false
			stop()
		else:
			seeing_player = true
	
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
	if target:
		navigation_agent_3d.set_target_position(target.global_position) # chase player with navigation
		var destination = navigation_agent_3d.get_next_path_position()
		var local_destination = destination - global_transform.origin
		var nav_direction = local_destination.normalized()
		velocity = nav_direction * type.speed
	else:
		pass
func attack():
	print("hiting you")

# the stoping of the chase
func stop():
	pass
