extends Control

@export var Inv: Inventory 
@onready var inv_slots : Array = $NinePatchRect/GridContainer.get_children()
@onready var ItemStackGuiClass = preload("res://Resources/Inventory/UI Scenes/item_stack_gui.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false
var item_in_hand: ItemStackGui

func _ready() -> void:
	Inv.updated.connect(update_slots)
	connect_slots()
	update_slots()
	visible = false
	is_open = false
	print(Inv.slots.size())
	print(inv_slots.size())

func connect_slots():
	for s in inv_slots:
		var callable = Callable(on_slot_clicked)
		callable = callable.bind(s)
		s.pressed.connect(callable)

func update_slots():
	for i in range(min(Inv.slots.size(), inv_slots.size())):
		var inventorySlot: InvSlot = Inv.slots[i]
		if !inventorySlot.item: continue
		var itemstackGui: ItemStackGui = inv_slots[i].item_stack_giu
		if !itemstackGui:
			itemstackGui = ItemStackGuiClass.instantiate()
			inv_slots[i].insert(itemstackGui)
		itemstackGui.inventorySlot = inventorySlot
		itemstackGui.update()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()

# let the mouse go
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GameManager.mouse_captured = false
	
# gimme the mouse
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.mouse_captured = true

func open():
	release_mouse()
	animation_player.play("Come in")
	visible = true
	is_open = true

func close():
	capture_mouse()
	animation_player.play("Leave")
	is_open = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Leave": # Close function but on time 
			visible = false
		
func on_slot_clicked(slot):
	print(slot)
	item_in_hand = slot.take_item()
