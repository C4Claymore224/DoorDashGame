extends Area3D
class_name Take_Item

@export var item : InvItem

func drop_off(inv: Inventory):
	inv.remove_at_space(GameManager.slot_selected)
