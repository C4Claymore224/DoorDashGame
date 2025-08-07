extends Node

var player_active: bool = true
var car_active: bool = false
var slot_selected: int = 0

var mouse_captured: bool = false

var car_selected: Automobile

func player_in_vehicle(vehicle: Automobile) -> void:
	car_selected = vehicle
