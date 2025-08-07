extends Button
class_name Slot

@onready var item_dis: Sprite2D = $CenterContainer/item_dis
@onready var amount: Label = $amount

var no_item : Texture = preload("uid://ce80f01bcu8au")
var def_text : String = "no item"

func update(slot: InvSlot):
	if slot.item:
		item_dis.texture = slot.item.hot_display
		amount.text = str(slot.count)
		if slot.count >= 2:
			amount.visible = true
	else:
		item_dis.texture = no_item
		amount.visible = false
