extends CharacterBody3D
class_name Player

const MAX_SPEED: float = 100

# head bobble stuff
const BOB_FREQ = 1.5
const BOB_AMP = .19
var bob_time = 0.0

@export var state_machiene: LimboHSM
@export var inv : Inventory

## States
@onready var idle_state: LimboState = $"StateMachiene/idle state"
@onready var walk_state: LimboState = $"StateMachiene/walk state"
@onready var sprint_state: LimboState = $"StateMachiene/sprint state"
@onready var jump_state: LimboState = $"StateMachiene/jump state"
@onready var falling_state: LimboState = $"StateMachiene/falling state"


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var play_anim: AnimationPlayer = $play_anim
@onready var ui_anim: AnimationPlayer = $UI/ui_anim
@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var lookcast: RayCast3D = $Head/Camera3D/lookcast
@onready var health_bar: ProgressBar = $"UI/bars/Health Bar"
@onready var stamina_bar: ProgressBar = $"UI/bars/Stamina Bar"
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var sensitivity : float = 0.005
var speed: float
var SPRINT_SPEED: float = 10.0
var WALK_SPEED : float = 6.0
var jump_hight : int = 300
var Max_Health: float = 100.0
var health: float = 50.0
var Max_Stamina: float = 3.0
var stamina: float = 3.0
var can_sprint : bool = true
var max_speed: bool = true
var item_holding: String

## State Stuff
var play_direction: Vector3
var is_sprinting: bool

# at the start get the mouse
func _ready() -> void:
	init_state_machiene()
	stamina_bar.max_value = Max_Stamina
	health_bar.max_value = Max_Health
	#capture_mouse()

func init_state_machiene():
	state_machiene.add_transition(state_machiene.ANYSTATE, idle_state,"to_idle")
	state_machiene.add_transition(idle_state, walk_state, "to_walk")
	state_machiene.add_transition(sprint_state, walk_state, "to_walk")
	state_machiene.add_transition(walk_state, sprint_state, "to_sprint")
	state_machiene.add_transition(state_machiene.ANYSTATE, jump_state,"to_jump")
	state_machiene.add_transition(state_machiene.ANYSTATE, falling_state,"to_fall")
	
	state_machiene.initial_state = idle_state
	state_machiene.initialize(self)
	state_machiene.set_active(true)

# Player Mouse camera movement
func _unhandled_input(event: InputEvent) -> void:
	if GameManager.mouse_captured and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera_3d.rotate_x(-event.relative.y * sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-80), deg_to_rad(50))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

func _physics_process(delta: float) -> void:
	$UI/Label.text = str(state_machiene.get_active_state().name)
	
	if GameManager.player_active:
		camera_3d.make_current()
		stamina_bar.value = stamina
		health_bar.value = health
		animated_sprite_2d.show()
		stamina_bar.show()
		health_bar.show()
		if stamina >= Max_Stamina:
			stamina = Max_Stamina
			if !can_sprint:
				can_sprint = true
				$"UI/bars/Stamina Bar/AnimationPlayer".stop()
		
	
		# interact by looking at things
		if lookcast.is_colliding():
			var target = lookcast.get_collider()
			if target != null and target.has_method("collect"): # drop off
				$UI/Croshairs/pickup.visible = true
				if Input.is_action_just_pressed("interact"):
					target.collect(inv)
			else:
				$UI/Croshairs/pickup.visible = false
			if target != null and target.has_method("drop_off"): # take item out of inv
				$UI/Croshairs/delete.visible = true
				if Input.is_action_just_pressed("interact"):
					target.drop_off(inv)
			else:
				$UI/Croshairs/delete.visible = false
			if target != null and target.has_method("give_item"): # pick up item
				$UI/Croshairs/pickup.visible = true
				if Input.is_action_just_pressed("interact"):
					target.give_item(inv)
			else:
				$UI/Croshairs/pickup.visible = false
				
			if target != null and target.has_method("get_player"): # Get in car
				# TODO: Optional croshair image
				pass
				if Input.is_action_just_pressed("interact"):
					GameManager.player_active = false
					GameManager.car_active = true
					target.get_player(self)
					collision_shape_3d.disabled = true
					global_position = target.global_position
					
			if target != null and target.has_method("fueling_self"): # Fueling car
				for i in inv.slots:
					if inv.slots[GameManager.slot_selected].item:
						$UI/Croshairs/Gass.visible = true
					else:
						$UI/Croshairs/Gass.visible = false
				if Input.is_action_just_pressed("fuel"):
					target.fueling_self(inv)
			else:
				$UI/Croshairs/Gass.visible = false 
				
			if target != null and target.has_method("move_door"): # open door
				pass
				if Input.is_action_just_pressed("interact"):
					target.move_door()
			else:
				pass
		else:
			$UI/Croshairs/Gass.visible = false
			$UI/Croshairs/pickup.visible = false
			$UI/Croshairs/delete.visible = false
		
		if $UI/Croshairs/pickup.visible == true or $UI/Croshairs/delete.visible == true or $UI/Croshairs/Gass.visible == true: # switches out crosshairs
			$UI/CenterContainer/crosshare.visible = false
		else:
			$UI/CenterContainer/crosshare.visible = true
		
		
			
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_hight * delta
			
		# handle direction iput
		var input_dir := Input.get_vector("left", "right", "frount", "back")
		var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		play_direction = direction
		# can control body in air with this 
		if is_on_floor():
			if direction:
				velocity.x = direction.x * speed
				velocity.z = direction.z * speed
			else:
				velocity.x = 0
				velocity.z = 0
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3)
		
		# handle sprint
		if Input.is_action_pressed("Sprint") and direction and is_on_floor():
			if can_sprint:
				is_sprinting = true
				speed = SPRINT_SPEED
				stamina -= delta
				if stamina <= 0:
					can_sprint = false
		else:
			if can_sprint:
				is_sprinting = false
				speed = WALK_SPEED
				stamina += delta
		#HeadBob <-- use hashtag today!
		bob_time += delta * velocity.length() * float(is_on_floor())
		camera_3d.transform.origin = _head_bob(bob_time)
		
		if bob_time >= 25:
			bob_time = 0
		
		if !can_sprint:
			$"UI/bars/Stamina Bar/AnimationPlayer".play("no_stam")
			speed = WALK_SPEED
			stamina += delta / 2 # slow regen rate
			
		manage_animations()
		move_and_slide()
	else:
		$UI/Croshairs/Gass.visible = false
		$UI/Croshairs/pickup.visible = false
		$UI/Croshairs/delete.visible = false
		animated_sprite_2d.hide()
		stamina_bar.hide()
		health_bar.hide()

# camera head bob function
func _head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

# let the mouse go
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.mouse_captured = false
	
# gimme the mouse
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.mouse_captured = true

## POWERUPS

func pizza_health_up(slot: InvSlot) -> void:
	health += slot.item.health_plus

func soda_speed_up(slot:InvSlot) -> void:
	
	$UI/Speedeffect.visible = true
	SPRINT_SPEED += slot.item.speed_plus
	WALK_SPEED += slot.item.speed_plus
	ui_anim.play("come_in")
	$Timers/speed_timer.start(slot.item.pow_time)

func _on_ui_anim_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"come_in":
			ui_anim.play("speed effect")
		"Hurt":
			$UI/HurtEffect.visible = false
			

func _on_speed_timer_timeout() -> void:
	ui_anim.play("leave")
	SPRINT_SPEED = 10
	WALK_SPEED = 6

func update_audio(audio_name: String) -> void:
	match audio_name:
		"walking":
			pass
		"stop":
			pass

func _on_player_audio_finished() -> void:
	print("done")

func take_damage(dmg: float):
	$UI/HurtEffect.visible = true
	ui_anim.play("Hurt")
	health -= dmg
	if health <= 0:
		health = 0
		death()

func manage_animations():
	for i in inv.slots:
		if !inv.slots[GameManager.slot_selected].wep and !inv.slots[GameManager.slot_selected].item:
			if Input.is_action_pressed("playerclick"):
				animated_sprite_2d.play("close")
			else:
				animated_sprite_2d.play("open")
		elif inv.slots[GameManager.slot_selected].wep:
			match inv.slots[GameManager.slot_selected].wep.name:
				"pistol":
					item_holding = "pistol"
					animated_sprite_2d.play("holding gun")
						
		elif inv.slots[GameManager.slot_selected].item:
			match inv.slots[GameManager.slot_selected].item.name:
				"Pizza":
					item_holding = "Pizza"
					animated_sprite_2d.play("pizza")
				"Soda":
					item_holding = "Soda"
					animated_sprite_2d.play("drink")
		else:
			pass

func manage_wepons():
	match item_holding:
		"pistol":
			pass

func death():
	print("ded")
