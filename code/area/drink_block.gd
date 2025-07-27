extends StaticBody3D

@export var item : InvItem

func give_item(inv: Inventory):
	inv.add_item(item)
