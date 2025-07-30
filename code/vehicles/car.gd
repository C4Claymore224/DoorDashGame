extends VehicleBody3D
class_name Automobile

# FIXME: pizza not refilling gas

const STOP = 0
const REGULAR_SPEED = 300

@export var storage: Inventory

@export var Max_Steer = 0.9
@export var Engine_Power = 300

@onready var camera_pivot: Node3D = $"Camera Pivot"
@onready var camera_3d: Camera3D = $"Camera Pivot/Camera3D"
@onready var gas_bar: ProgressBar = $"Car Hud/Gas"
@onready var car_health_bar: ProgressBar = $"Car Hud/Car Health"
@onready var leave_spot_pos: Marker3D = $"leave spot"
@onready var player_seat_pos: Marker3D = $"player seat"
@onready var speed_pow_timer: Timer = $"speed pow timer"
@onready var speed_cooldown: Timer = $"speed cooldown"

var max_health : float = 100
var health : float = 80

var max_tank_gas: float = 30
var gas_in_tank: float = 15
var can_drive: bool = true

var player

func _ready() -> void:
	gas_bar.max_value = max_tank_gas
	car_health_bar.max_value = max_health
	
func _physics_process(delta: float) -> void:
	if gas_in_tank >= max_tank_gas:
		gas_in_tank = max_tank_gas
	if gas_in_tank <= 0:
		gas_in_tank = 0
		can_drive = false
	else:
		can_drive = true
	if health >= max_health:
		health = max_health
	if health <= 0:
		print("dead")
	if GameManager.car_active:
		GameManager.player_in_vehicle(self)
		camera_3d.make_current()
		gas_bar.show()
		car_health_bar.show()
		gas_bar.value = gas_in_tank
		car_health_bar.value = health
		steering = move_toward(steering, Input.get_axis("right","left") * Max_Steer, delta * 10) # moves frount tires
		engine_force = Input.get_axis("frount", "back") * Engine_Power # moves car
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		
		if player:
			player.global_position = player_seat_pos.global_position # works fix later
		
		if Input.is_action_just_pressed("leave car"):
				exit_car() # player leaves car
		if can_drive:
			Engine_Power = REGULAR_SPEED
			if engine_force:
				gas_in_tank -= delta
		else:
			Engine_Power = STOP
	else:
		gas_bar.hide()
		car_health_bar.hide()

func exit_car() -> void:
	GameManager.car_active = false
	GameManager.player_active = true
	player.collision_shape_3d.disabled = false
	player.global_position = leave_spot_pos.global_position
	can_drive = false

func get_player(vessl: Player):
	player = vessl
	
func take_item(inv: Inventory):
	for i in inv.inv_items.size():
		if inv.inv_items[GameManager.slot_selected]:
			add_gas(inv.inv_items[GameManager.slot_selected])
			inv.remove_at_space(GameManager.slot_selected)
			break

func add_gas(item: InvItem) -> void:
	match item.name:
		"Pizza":
			gas_in_tank += item.gas_amount
			print(gas_in_tank)
		"Soda":
			gas_in_tank += item.gas_amount
			print(gas_in_tank)

func use_powerup(item: InvItem):
	match item.name:
		"Pizza":
			health += item.health_plus
		"Soda":
			Engine_Power += item.health_plus
			speed_pow_timer.start()

func _on_speed_pow_timer_timeout() -> void:
	Engine_Power = REGULAR_SPEED
	
