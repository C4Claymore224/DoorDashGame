extends Resource
class_name Inventory

signal updated

@export var slots: Array[InvSlot] = []

# inserts item into inv
func add_item(item: InvItem) -> void:
	for s in slots:
		if s.item == item:
			s.count += 1
			updated.emit()
			return
	
	for i in range(slots.size()):# go over every space in the inventory
		if !slots[i].item: # if there is nothing in the space
			slots[i].item = item # that space gets an item
			slots[i].count = 1
			return
	updated.emit()
	
#func remove_item(item: InvItem) -> void:
	#for i in slots.size():
		#if slots[i] == item:
			#slots[i] = null # makes spot empty
			#updated.emit()
			#break
		#else:
			#continue

## better version of the remove item func
func remove_at_space(index: int) -> void:
	if slots[index].item: # inventory space
		slots[index].item = null # takes out item
		updated.emit() # updates the ui
	else:
		print("nothin")
