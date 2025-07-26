extends Panel
class_name Hotbar

@export var inv : Inventory
@onready var slots : Array = $contaner.get_children()

var curently_selected: int = 0

func _ready() -> void:
	inv.updated.connect(update)
	update()

func update():
	for i in range(min(inv.inv_items.size(), slots.size())): # when this is called, for every slot in the inv
		slots[i].update(inv.inv_items[i]) # visually change the slot to whatever it is

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use item"):
		pass
