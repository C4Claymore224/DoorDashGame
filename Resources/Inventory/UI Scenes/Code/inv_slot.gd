extends Button

@onready var item_display: TextureRect = $CenterContainer/ItemDisplay
@onready var label: Label = $Label

var no_item : Texture = preload("uid://jep2cneoospv")
var def_text : String = "no item"

var item_name: String

func update(slot: InvSlot):
	if slot.item:
		item_display.texture = slot.item.inv_display
		item_name = slot.item.name
		label.text = str(slot.count)
		label.visible = true
	else:
		item_display.texture = no_item
		label.visible = false

func _on_pressed() -> void:
	match item_name:
		"Pizza":
			print("Pizza")
		"Soda":
			print("Soda")
