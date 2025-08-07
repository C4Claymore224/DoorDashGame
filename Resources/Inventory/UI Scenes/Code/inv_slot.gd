extends Button


@onready var bg: TextureRect = $BG
@onready var center_container: CenterContainer = $CenterContainer

var item_stack_giu: ItemStackGui

var def_text : String = "no item"

var item_name: String

func insert(isg: ItemStackGui):
	item_stack_giu = isg
	center_container.add_child(item_stack_giu)

func take_item():
	var item = item_stack_giu
	
	center_container.remove_child(item_stack_giu)
	item_stack_giu = null
	return item
