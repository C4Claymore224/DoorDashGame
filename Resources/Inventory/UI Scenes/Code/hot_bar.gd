extends Panel
class_name Hotbar

@export var inv : Inventory
@export var player: Player
@onready var slots : Array = $contaner.get_children()
@onready var selector: Sprite2D = $Selector

var vehicle: Automobile 


func _ready() -> void:
	inv.updated.connect(update)
	update()
	selector.position = Vector2(-1.5,-1)
	pick_slot(0)

func update():
	for i in range(min(inv.slots.size(), slots.size())): # when this is called, for every slot in the inv
		slots[i].update(inv.slots[i]) # visually change the slot to whatever it is

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use item"):
		if GameManager.player_active:
			player_use_picked_item()
		elif GameManager.car_active:
			vehicle_use_picked_item()
	
	# scroll wheel useage!!!
	if event.is_action_pressed("Wheelup"):
		pick_slot(GameManager.slot_selected - 1)
	if event.is_action_pressed("Wheeldown"):
		pick_slot(GameManager.slot_selected + 1)
		
	# Picks slot to use
	if event.is_action_pressed("slot1"):
		pick_slot(0)
	if event.is_action_pressed("slot2"):
		pick_slot(1)
	if event.is_action_pressed("slot3"):
		pick_slot(2)
	if event.is_action_pressed("slot4"):
		pick_slot(3)
	if event.is_action_pressed("slot5"):
		pick_slot(4)
		

func pick_slot(index: int):
	if index >= 0 and index < inv.slots.size():
		GameManager.slot_selected = index
	match index:
		0:
			selector.position = Vector2(-1.5,-1.0)
		1:
			selector.position = Vector2(77.5,-1.0)
		2:
			selector.position = Vector2(156.5,-1.0)
		3:
			selector.position = Vector2(235.5,-1.0)
		4:
			selector.position = Vector2(314.5,-1.0)

func player_use_picked_item():
	if GameManager.slot_selected != -1:
		var slot = inv.slots[GameManager.slot_selected]
		if slot.item:
			match slot.item.name:
				"Pizza":
					player.pizza_health_up(slot)
					inv.remove_at_space(GameManager.slot_selected)
				"Soda":
					player.soda_speed_up(slot)
					inv.remove_at_space(GameManager.slot_selected)
		else:
			# TODO: Add a freaking error sound here 
			print("nuh uh")

func vehicle_use_picked_item():
	if GameManager.slot_selected != -1:
		var slot = inv.slots[GameManager.slot_selected]
		if slot:
			match slot.item.name:
				"Pizza":
					GameManager.car_selected.use_powerup(slot)
					inv.remove_at_space(GameManager.slot_selected)
				"Soda":
					GameManager.car_selected.use_powerup(slot)
					inv.remove_at_space(GameManager.slot_selected)
		else:
			print("nuh uh lil bro")
