class_name StateManager
extends Node

signal state_updated

var current_state: GameState

func initialize(width: int, height: int) -> void:
	randomize()
	current_state = GameState.new(width, height)
	_generate_initial_state()
	emit_signal("state_updated")
	print("State initialized with size: ", width, "x", height)
	print("Total hexes: ", len(current_state.hex_grid))

func _generate_initial_state() -> void:
	for q in range(current_state.width):
		for r in range(current_state.height):
			var hex_pos = Vector2(q, r)
			current_state.hex_grid[hex_pos] = {
				"biome": _random_biome(),
				"occupied": null
			}

static func _random_biome() -> Dictionary:
	var chance = randf()
	if chance < 0.4:
		return BiomeData.create_woods()
	elif chance < 0.7:
		return BiomeData.create_desert()
	elif chance < 0.9:
		return BiomeData.create_cave()
	else:
		return BiomeData.create_water()

func place_entity(entity: Node, _pos: Vector2) -> bool:  # Added underscore to unused parameter
	# Get a list of all available positions
	var available_positions = []
	for pos in current_state.hex_grid.keys():
		var hex_data = current_state.hex_grid[pos]
		if hex_data["biome"]["walkable"] and hex_data["occupied"] == null:
			available_positions.append(pos)
	
	if available_positions.empty():
		print("No available positions to place character!")
		return false
	
	# Choose a random available position
	var chosen_pos = available_positions[randi() % available_positions.size()]
	var hex_data = current_state.hex_grid[chosen_pos]
	
	# Place the character
	hex_data["occupied"] = entity
	current_state.entity_positions[chosen_pos] = entity
	if entity is Character:
		entity.position = chosen_pos
		print("Placed character at position: ", chosen_pos, " with team color: ", entity.team_color)
	
	emit_signal("state_updated")
	return true
