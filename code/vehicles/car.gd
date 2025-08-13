extends VehicleBody3D
class_name Automobile

const STOP = 0
const REGULAR_SPEED = 300

@export var storage: Inventory

@export var Max_Steer = 0.9
@export var Engine_Power = 300

## LIGHTS
@onready var fright: SpotLight3D = $Fright
@onready var fleft: SpotLight3D = $Fleft
@onready var bleft: SpotLight3D = $Bleft
@onready var b_right: SpotLight3D = $BRight

@onready var camera_pivot: Node3D = $"Camera Pivot"
@onready var camera_3d: Camera3D = $"Camera Pivot/Camera3D"
@onready var gas_bar: ProgressBar = $"Car Hud/Gas"
@onready var car_health_bar: ProgressBar = $"Car Hud/Car Health"
@onready var leave_spot_pos: Marker3D = $"leave spot"
@onready var player_seat_pos: Marker3D = $"player seat"
@onready var speed_pow_timer: Timer = $"speed pow timer"
@onready var speed_cooldown: Timer = $"speed cooldown"

var ram_damae : int = 3

var max_health : float = 100
var health : float = 80
var max_tank_gas: float = 30.0
var gas_in_tank: float = 15
var can_drive: bool = true
var player
var direction: float
var is_car_reved := false

func _ready() -> void:
	gas_bar.max_value = max_tank_gas
	car_health_bar.max_value = max_health
	
func _physics_process(delta: float) -> void:
	if gas_in_tank >= max_tank_gas:
		gas_in_tank = max_tank_gas
	if gas_in_tank <= 0:
		gas_in_tank = 0
		can_drive = false # car cant fucntion untill refueled
	else:
		can_drive = true
		
	if health >= max_health:
		health = max_health
	if health <= 0: 
		print("dead")
		
	if GameManager.car_active:
		fleft.light_energy = 8
		fright.light_energy = 8
		GameManager.player_in_vehicle(self)
		camera_3d.make_current()
		gas_bar.show()
		car_health_bar.show()
		gas_bar.value = gas_in_tank
		car_health_bar.value = health
		steering = move_toward(steering, Input.get_axis("right","left") * Max_Steer, delta * 10) # moves frount tires
		direction = Input.get_axis("frount", "back")
		engine_force = direction * Engine_Power # moves car
		camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)
		
		if direction == 1.0 and can_drive:
			bleft.light_energy = 8
			b_right.light_energy = 8
			fleft.light_energy = 0.1
			fright.light_energy = 0.1
		else:
			bleft.light_energy = 0
			b_right.light_energy = 0
			
		if player:
			player.visible = false
			player.global_position = player_seat_pos.global_position # works fix later
		
		if Input.is_action_just_pressed("leave car"):
				exit_car()
		
		if can_drive:
			Engine_Power = REGULAR_SPEED
			if engine_force:
				gas_in_tank -= delta # / 2 adding this makes gass go slower keep in mind
		else:
			fleft.light_energy = 0
			fright.light_energy = 0
			bleft.light_energy = 0
			b_right.light_energy = 0
			Engine_Power = STOP
			is_car_reved = false
	else:
		fleft.light_energy = 0
		fright.light_energy = 0
		bleft.light_energy = 0
		b_right.light_energy = 0
		gas_bar.hide()
		car_health_bar.hide()

func exit_car() -> void:
	GameManager.car_active = false
	GameManager.player_active = true
	player.global_position = leave_spot_pos.global_position
	player.visible = true
	player.collision_shape_3d.disabled = false
	can_drive = false

func get_player(ply: Player):
	player = ply

func fueling_self(inv: Inventory):
	if !gas_in_tank >= max_tank_gas:
		for i in inv.slots.size():
			if inv.slots[GameManager.slot_selected]:
				add_gas(inv.slots[GameManager.slot_selected])
				inv.remove_at_space(GameManager.slot_selected)
				break
	else:
		print("TANK FULL")

func add_gas(slot: InvSlot) -> void:
	if slot.item:
		match slot.item.name:
			"Pizza":
				gas_in_tank += slot.item.gas_amount
				print(gas_in_tank)
			"Soda":
				gas_in_tank += slot.item.gas_amount
				print(gas_in_tank)

func use_powerup(slot: InvSlot):
	match slot.item.name:
		"Pizza":
			health += slot.item.health_plus
		"Soda":
			Engine_Power += slot.item.health_plus
			$GPUParticles3D.emitting = true
			$GPUParticles3D2.emitting = true
			speed_pow_timer.start()

func _on_speed_pow_timer_timeout() -> void:
	Engine_Power = REGULAR_SPEED
	$GPUParticles3D.emitting = true
	$GPUParticles3D2.emitting = true

func _on_runover_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enem"):
		body.take_damage(ram_damae)
