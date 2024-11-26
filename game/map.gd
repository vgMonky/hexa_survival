class_name GameMap
extends Node

# Map Manager static functions
static func create_hex_grid(grid_width: int, grid_height: int) -> Dictionary:
	randomize()
	
	var grid_data = {}
	
	for q in range(grid_width):
		for r in range(grid_height):
			var hex_pos = Vector2(q, r)  # Using Vector2 for simplicity
			grid_data[hex_pos] = {
				"biome": _random_biome(),
				"occupied": null
			}
			
	return grid_data

static func _random_biome() -> Dictionary:
	# Simple random distribution for now
	var chance = randf()
	if chance < 0.4:
		return BiomeData.create_woods()
	elif chance < 0.7:
		return BiomeData.create_desert()
	elif chance < 0.9:
		return BiomeData.create_cave()
	else:
		return BiomeData.create_water()

# Map instance variables and functions
signal map_updated

var map_width: int
var map_height: int
var hex_data: Dictionary = {}



var turn_manager: TurnManager

func initialize(new_width: int, new_height: int) -> void:
	map_width = new_width
	map_height = new_height
	hex_data = create_hex_grid(map_width, map_height)
	
	# Create turn manager
	turn_manager = TurnManager.new()
	add_child(turn_manager)
	
	emit_signal("map_updated")

func start_game(red_team: Array, pink_team: Array) -> void:
	turn_manager.initialize(red_team, pink_team)
	turn_manager.start_game()

func get_hex_data(pos: Vector2) -> Dictionary:
	return hex_data.get(pos, {})

# Added this function
func place_character(character: Character) -> bool:
	# Find random walkable position
	var available_positions = []
	for pos in hex_data.keys():
		if hex_data[pos]["biome"]["walkable"] and hex_data[pos]["occupied"] == null:
			available_positions.append(pos)
	
	if available_positions.empty():
		return false
	
	# Select random position
	var pos = available_positions[randi() % available_positions.size()]
	
	# Place character
	hex_data[pos]["occupied"] = character
	character.position = pos
	emit_signal("map_updated")
	return true


