extends Resource
class_name Inventory

signal updated

@export var slots: Array[InvSlot] = []

# inserts item into inv
func add_item(item: InvItem) -> void:
	for s in slots:
		if s.item == item:
			if !s.count >= s.item.max_itemPrStack:
				s.count += 1
				updated.emit()
				return
	for i in range(slots.size()):# go over every space in the inventory
			if !slots[i].item: # if there is nothing in the space
				slots[i].item = item # that space gets an item
				slots[i].count = 1
				updated.emit()
				return


## better version of the remove item func
func remove_at_space(index: int) -> void:
	if slots[index].item: # inventory space
		slots[index].count -= 1
		if slots[index].count == 0:
			slots[index].count = 0
			slots[index].item = null
		updated.emit() # updates the ui
	else:
		print("nothin")
