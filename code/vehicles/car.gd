extends VehicleBody3D


@export var Max_Steer = 0.9
@export var Engine_Power = 300

@onready var camera_pivot: Node3D = $"Camera Pivot"
@onready var camera_3d: Camera3D = $"Camera Pivot/Camera3D"
@onready var player_spot: Marker3D = $player_spot

var player

func _physics_process(delta: float) -> void:
	if GameManager.car_active:
		camera_3d.make_current()
		steering = move_toward(steering, Input.get_axis("right","left") * Max_Steer, delta * 10)
		engine_force = Input.get_axis("frount", "back") * Engine_Power
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		if Input.is_action_just_pressed("use item"):
			exit_car()

func exit_car() -> void:
	GameManager.car_active = false
	GameManager.player_active = true
	player.collision_shape_3d.disabled = false
	player.global_position = player_spot.global_position

func get_player(vessl: Player):
	player = vessl
	vessl.hide()
