extends Panel
class_name ItemStackGui

var no_item : Texture = preload("uid://jep2cneoospv")
@onready var item_display: TextureRect = $ItemDisplay
@onready var amount: Label = $Amount

var inventorySlot: InvSlot

func update():
	if inventorySlot || inventorySlot.item: return
	
	item_display.texture = inventorySlot.item.inv_display
	amount.text = str(inventorySlot.count)
	if inventorySlot.count >= 2:
		amount.visible = true
	else:
		item_display.texture = no_item
		amount.visible = false
	
