class_name GameMap
extends Node

# Map Manager static functions
static func create_hex_grid(grid_width: int, grid_height: int) -> Dictionary:
	var grid_data = {}
	
	for q in range(grid_width):
		for r in range(grid_height):
			var hex_pos = Vector2(q, r)  # Using Vector2 for simplicity
			grid_data[hex_pos] = {}  # Empty dictionary for future hex data
			
	return grid_data

# Map instance variables and functions
signal map_updated

var map_width: int
var map_height: int
var hex_data: Dictionary = {}

func initialize(new_width: int, new_height: int) -> void:
	map_width = new_width
	map_height = new_height
	hex_data = create_hex_grid(map_width, map_height)
	emit_signal("map_updated")

func get_hex_data(pos: Vector2) -> Dictionary:
	return hex_data.get(pos, {})
