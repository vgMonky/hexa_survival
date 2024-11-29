# game/systems/movement_system.gd
class_name MovementSystem
extends BaseSystem

const MAX_HEX_STEPS = 4  # Renamed for clarity

# Added to store pathfinding info
var path_costs = {}  # pos -> shortest path length to reach it
var paths = {}      # pos -> path to reach it

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"get_valid_moves":
			return get_valid_moves(current_state, event.character_id)
		"move_character":
			return validate_and_move_character(current_state, event)
	return {}

func get_valid_moves(state: GameState, character_id: String) -> Dictionary:
	if state.turn_data.moves_left <= 0:
		return {
			"type": "valid_moves",
			"character_id": character_id,
			"valid_positions": []
		}
	
	var character = state.entities.characters[character_id]
	var start_pos = character.position
	
	# Reset pathfinding data
	path_costs.clear()
	paths.clear()
	
	# Dijkstra's algorithm
	var to_visit = []  # Priority queue would be better
	to_visit.append(start_pos)
	path_costs[start_pos] = 0
	paths[start_pos] = [start_pos]
	
	var valid_moves = []
	
	while not to_visit.empty():
		var current = to_visit.pop_front()
		var current_cost = path_costs[current]
		
		# Don't explore beyond max steps
		if current_cost >= state.turn_data.moves_left:
			continue
		
		# Check each adjacent hex
		for direction in get_adjacent_offsets():
			var next_pos = current + direction
			var new_cost = current_cost + 1
			
			# Only process if it's a valid move and either unvisited or found a shorter path
			if is_valid_move(state, next_pos) and (not path_costs.has(next_pos) or new_cost < path_costs[next_pos]):
				path_costs[next_pos] = new_cost
				paths[next_pos] = paths[current].duplicate()
				paths[next_pos].append(next_pos)
				to_visit.append(next_pos)
				valid_moves.append(next_pos)
	
	return {
		"type": "valid_moves",
		"character_id": character_id,
		"valid_positions": valid_moves,
		"path_costs": path_costs  # Include path costs for visualization
	}

func validate_and_move_character(state: GameState, event: Dictionary) -> Dictionary:
	print("[Movement System] Starting move validation. Current moves left:", state.turn_data.moves_left)
	
	var target_pos = event.new_position
	
	# Check if we have a valid path to this position
	if not path_costs.has(target_pos):
		print("[Movement System] No valid path to position:", target_pos)
		return {}
	
	var path_cost = path_costs[target_pos]
	if path_cost > state.turn_data.moves_left:
		print("[Movement System] Not enough moves left. Need:", path_cost)
		return {}
	
	var old_position = state.entities.characters[event.character_id].position
	var new_moves_left = max(0, state.turn_data.moves_left - path_cost)
	
	print("[Movement System] Moving character from", old_position, "to", target_pos)
	print("[Movement System] Path cost:", path_cost)
	print("[Movement System] Moves left after this move:", new_moves_left)
	
	return {
		"type": "move_character",
		"character_id": event.character_id,
		"old_position": old_position,
		"new_position": target_pos,
		"moves_left": new_moves_left
	}
	
func get_adjacent_offsets() -> Array:
	return [
		Vector2(1, 0),   # right
		Vector2(1, -1),  # up-right
		Vector2(0, -1),  # up-left
		Vector2(-1, 0),  # left
		Vector2(-1, 1),  # down-left
		Vector2(0, 1)    # down-right
	]

func is_valid_move(state: GameState, pos: Vector2) -> bool:
	if not state.map_data.hexes.has(pos):
		return false
	
	var hex_data = state.map_data.hexes[pos]
	
	if not hex_data.biome_data.walkable:
		return false
	
	if hex_data.entity != null:
		return false
		
	return true
