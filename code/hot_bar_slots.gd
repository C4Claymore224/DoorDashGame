extends Button

class_name Slot


@onready var item_dis: Sprite2D = $CenterContainer/item_dis


var default_pic : Texture = preload("res://Assets/no_item.png")
var def_text : String = "no item"

func update(item: InvItem):
	if item:
		item_dis.texture = item.display
	else:
		item_dis.texture = default_pic
