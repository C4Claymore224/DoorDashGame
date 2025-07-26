extends Resource
class_name Inventory

signal updated
#signal inv_full

@export var inv_items: Array[InvItem] = []


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

			

#func use_item_at_slot(index: int) -> void:
	#if index < 0 || index >= inv_items.size() || ! inv_items[index]: return
#
#func remove_at_index(index: int) -> void:
	#pass
