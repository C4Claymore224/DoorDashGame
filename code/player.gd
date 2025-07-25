extends CharacterBody3D
class_name Player


## Notes for future player additons
#	have the player hold the item for example a pizza
#	make some kind of weapon
#	

# head bobble stuff
const BOB_FREQ = 1.5
const BOB_AMP = .19
var bob_time = 0.0

@export var inv : Inventory

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var lookcast: RayCast3D = $Head/Camera3D/lookcast
@onready var hand: Node3D = $Head/hand
@onready var stamina_bar: ProgressBar = $"UI/Stamina Bar"
@onready var place: Label = $UI/place
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


var sensitivity : float = 0.005
var speed: int
const SPRINT_SPEED: int = 10
const  WALK_SPEED : int = 6
const  JUMP_HEIGHT : int = 300

var Max_Stamina: float = 3 
var stamina: float = 3
var can_sprint : bool = true

var gravity = 9.1

var mouse_captured : bool = false

# at the start get the mouse
func _ready() -> void:
	stamina_bar.max_value = Max_Stamina
	capture_mouse()

# Player Mouse camera movement
func _unhandled_input(event: InputEvent) -> void:
	if mouse_captured and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera_3d.rotate_x(-event.relative.y * sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-60), deg_to_rad(40))
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()

func _physics_process(delta: float) -> void:
	if GameManager.player_active:
		camera_3d.make_current()
		if stamina >= Max_Stamina:
			stamina = Max_Stamina
			if !can_sprint:
				can_sprint = true
		stamina_bar.value = stamina
		
		# interact by looking at things
		if lookcast.is_colliding():
			var target = lookcast.get_collider()
			if target != null and target.has_method("collect"):
				$UI/pickup.show()
				if Input.is_action_just_pressed("interact"):
					target.collect(inv)
			else:
				$UI/pickup.hide()
			if target != null and target.has_method("take_item"):
				place.show()
				if Input.is_action_just_pressed("interact"):
					target.take_item(inv)
			else:
				place.hide()
				
			if target != null and target.has_method("get_player"):
				pass
				if Input.is_action_just_pressed("interact"):
					GameManager.player_active = false
					GameManager.car_active = true
					target.get_player(self)
					collision_shape_3d.disabled = true
			else:
				pass
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_HEIGHT * delta
			
		# handle direction iput
		var input_dir := Input.get_vector("left", "right", "frount", "back")
		var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
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
		
		
		#handle sprint
		if Input.is_action_pressed("Sprint") and direction:
			if can_sprint:
				speed = SPRINT_SPEED
				stamina -= delta
				if stamina <= 0:
					can_sprint = false
			else:
				speed = WALK_SPEED
				stamina += delta # slow regen rate
		else:
			speed = WALK_SPEED
			stamina += delta
		
		#HeadBob <-- use hashtoday!
		bob_time += delta * velocity.length() * float(is_on_floor())
		camera_3d.transform.origin = _head_bob(bob_time)
		
		if bob_time >= 25:
			bob_time = 0

		move_and_slide()
	else:
		pass

# camera head bob function
func _head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

# let the mouse go
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
# gimme the mouse
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
