extends LimboHSM

@export var charicter: CharacterBody3D

## States
@onready var idle_state: LimboState = $"idle state"
@onready var walk_state: LimboState = $"walk state"
@onready var sprint_state: LimboState = $"sprint state"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_state = idle_state
	initialize(charicter)
	set_active(true)
