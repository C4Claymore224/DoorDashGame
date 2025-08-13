extends CharacterBody3D
class_name Enemy

@export var type: Enem_Type

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var animation_player: AnimationPlayer = $Skeleton_Minion/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var sight: RayCast3D = $Sight
@onready var bt_player: BTPlayer = $BTPlayer

var target : Player
var in_range_to_attack: bool = false
var seeing_player: bool = true
var can_attack: bool = false
var play_dis

func _ready() -> void:
	bt_player.blackboard.set_var("State", "wonder")

func _physics_process(delta: float) -> void:
	# We sense the player
	if target:
		sight.enabled = true
		look_at(target.global_position) # look at him
		var distance = global_position.distance_to(target.global_position)
		play_dis = distance
		if distance <= type.attack_range:
			in_range_to_attack = true
		else:
			in_range_to_attack = false
		if distance >= type.stop_persuit:
			stop()
	else:
		sight.enabled = false
		
	if sight.is_colliding():
		var sight_body = sight.get_collider()
		if !sight_body.has_method("_head_bob"): # If im not looking at the player
			seeing_player = false
		else:
			seeing_player = true
	
	if not is_on_floor():
		velocity.y -= 9.2 * delta


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
		bt_player.blackboard.set_var("State", "persue")
		bt_player.restart()

# follow target
func follow_target() -> void:
	if target:
		navigation_agent_3d.set_target_position(target.global_position) # chase player with navigation
		var destination = navigation_agent_3d.get_next_path_position()
		var local_destination = destination - global_transform.origin
		var nav_direction = local_destination.normalized()
		velocity = nav_direction * type.speed

func attack_player():
	if target:
		target.take_damage(type.damage)

# stop persuing
func stop():
	#position = Vector3(-9,2,16)
	target = null
	velocity = Vector3.ZERO
	bt_player.blackboard.set_var("State", "wonder")
	bt_player.restart()

func idle_wonder(target_pos: Vector3): # limboai function
	var direction := Vector3(
		target_pos.x - global_transform.origin.x,
		0,
		target_pos.z - global_transform.origin.z
	).normalized()
	
	velocity.x = direction.x * type.speed
	velocity.z = direction.z * type.speed

func take_damage(dmg: int) -> void:
	type.health -= dmg
	print(type.health)
	if type.health <= 0:
		death()

func death():
	type.speed = 0
	$Skeleton_Minion.visible = false
	animated_sprite_3d.visible = true
	animated_sprite_3d.play("death")


func _on_animated_sprite_3d_animation_finished() -> void:
	match animated_sprite_3d.animation:
		"death":
			queue_free()
	
