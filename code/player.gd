extends CharacterBody3D

# head bobble stuff
const BOB_FREQ = 1.5
const BOB_AMP = .19
var bob_time = 0.0

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D

var sensitivity : float = 0.005
var speed: float
const SPRINT_SPEED: int = 400
const  WALK_SPEED : int = 250
const  jump_height : float = 350

var gravity = 9.2

var mouse_captured : bool = false

func _ready() -> void:
	capture_mouse()

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
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "frount", "back")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.z = move_toward(velocity.z, 0, speed * delta)
	
	
	#handle sprint
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	#HeadBob <-- use hashtoday!
	bob_time += delta * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = _head_bob(bob_time)

	move_and_slide()

func _head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
