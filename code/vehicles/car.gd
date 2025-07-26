extends VehicleBody3D
class_name Automobile

const STOP = 0
const REGULAR_SPEED = 300

@export var storage: Inventory
#@export var item: InvItem

@export var Max_Steer = 0.9
@export var Engine_Power = 300

@onready var camera_pivot: Node3D = $"Camera Pivot"
@onready var camera_3d: Camera3D = $"Camera Pivot/Camera3D"
@onready var player_spot: Marker3D = $player_spot
@onready var gas: ProgressBar = $"Car Hud/Gas"

var max_tank_gas: float = 15
var gas_in_tank: float = 15
var can_drive: bool = true

var player

func _ready() -> void:
	gas.max_value = max_tank_gas

func _physics_process(delta: float) -> void:
	if gas_in_tank >= max_tank_gas:
		gas_in_tank = max_tank_gas
	if gas_in_tank <= 0:
		gas_in_tank = 0
		can_drive = false
	else:
		can_drive = true
	if GameManager.car_active:
		camera_3d.make_current()
		gas.show()
		gas.value = gas_in_tank
		steering = move_toward(steering, Input.get_axis("right","left") * Max_Steer, delta * 10) # moves frount tires
		engine_force = Input.get_axis("frount", "back") * Engine_Power # moves car
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		if Input.is_action_just_pressed("use item"):
				exit_car() # player leaves car
		if can_drive:
			Engine_Power = REGULAR_SPEED
			if engine_force:
				gas_in_tank -= delta
		else:
			Engine_Power = STOP
	else:
		gas.hide()

func exit_car() -> void:
	GameManager.car_active = false
	GameManager.player_active = true
	player.collision_shape_3d.disabled = false
	player.global_position = player_spot.global_position
	can_drive = false

func get_player(vessl: Player):
	player = vessl
	vessl.hide()
	
func take_item(inv: Inventory):
	for i in inv.inv_items.size():
		if inv.inv_items[i]:
			add_gas(inv.inv_items[i])
			inv.remove_at_space(GameManager.slot_selected)
			break
	
func add_gas(item: InvItem) -> void:
	match item.name:
		"Pizza":
			gas_in_tank += item.gas_amount
