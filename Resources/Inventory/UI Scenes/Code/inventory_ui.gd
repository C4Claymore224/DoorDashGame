extends Control

@export var Inv: Inventory 
@onready var inv_slots : Array = $NinePatchRect/GridContainer.get_children()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func _ready() -> void:
	Inv.updated.connect(update_slots)
	update_slots()
	visible = false
	is_open = false
	print(Inv.slots.size())
	print(inv_slots.size())

func update_slots():
	for i in range(min(Inv.slots.size(), inv_slots.size())):
		inv_slots[i].update(Inv.slots[i])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	animation_player.play("Come in")
	visible = true
	is_open = true

func close():
	animation_player.play("Leave")
	is_open = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Leave": # Close function but on time 
			visible = false
