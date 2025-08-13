extends Resource
class_name Weapon

@export var inv_image: Texture
@export var game_image: Texture
@export var name: String
@export_enum("Melee", "Ranged", "Explosives") var Types : int
