extends Button

class_name Slot


@onready var item_dis: Sprite2D = $CenterContainer/item_dis


var no_item : Texture = preload("uid://ce80f01bcu8au")
var def_text : String = "no item"

func update(item: InvItem):
	if item:
		item_dis.texture = item.display
	else:
		item_dis.texture = no_item
