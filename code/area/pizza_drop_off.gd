extends Area3D
class_name Take_Item

@export var item : InvItem

func take_item(inv: Inventory):
	inv.remove_item(item)
