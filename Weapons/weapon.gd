extends Node3D

@export var weapon_type: Weapons
	#set(value):
		#weapon_type = value
		#load_weapon()
		#if Engine.is_editor_hint():
			#load_weapon()

@onready var weapon_mesh: MeshInstance3D = %weapon_mesh
@onready var shadow: MeshInstance3D = %Shadow

func _ready() -> void:
	load_weapon()

func load_weapon():
	weapon_mesh.mesh = weapon_type.mesh
	position = weapon_type.position
	rotation = weapon_type.rotation
	shadow.visible = weapon_type.shadow
