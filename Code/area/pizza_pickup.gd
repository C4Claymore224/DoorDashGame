extends RigidBody3D

@export var item : InvItem

func _ready() -> void:
	pass

func collect(inventory: Inventory) -> void:
	inventory.add_item(item)
	queue_free()
