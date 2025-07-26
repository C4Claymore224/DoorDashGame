extends Resource
class_name Inventory

signal updated

@export var inv_items: Array[InvItem] = []

# inserts item into inv
func add_item(item: InvItem) -> void:
	for i in range(inv_items.size()):# go over every space in the inventory
		if !inv_items[i]: # if there is nothing in the space
			inv_items[i] = item # that space gets an item
			break
		
	updated.emit()

func remove_item(item: InvItem) -> void:
	for i in inv_items.size():
		if inv_items[i] == item:
			inv_items[i] = null # makes spot empty
			updated.emit()
			break
		else:
			continue

## better version of the remove item func
func remove_at_space(index: int) -> void:
	if inv_items[index]: # inventory space
		inv_items[index] = null # takes out item
		updated.emit() # updates the ui
	else:
		print("nothin")
