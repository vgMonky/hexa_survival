# game/systems/movement_system.gd
class_name MovementSystem
extends BaseSystem

const MAX_MOVE = 4

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
	var current_pos = character.position
	var valid_moves = []
	
	for direction in get_adjacent_offsets():
		var target_pos = current_pos + direction
		if is_valid_move(state, target_pos):
			valid_moves.append(target_pos)
	
	return {
		"type": "valid_moves",
		"character_id": character_id,
		"valid_positions": valid_moves
	}

func validate_and_move_character(state: GameState, event: Dictionary) -> Dictionary:
	print("[Movement System] Starting move validation. Current moves left:", state.turn_data.moves_left)
	
	if state.turn_data.moves_left <= 0:
		print("[Movement System] No moves left this turn")
		return {}

	var valid_moves = get_valid_moves(state, event.character_id)
	
	if not event.new_position in valid_moves.valid_positions:
		print("[Movement System] Invalid position:", event.new_position)
		return {}
		
	var old_position = state.entities.characters[event.character_id].position
	var new_moves_left = max(0, state.turn_data.moves_left - 1)  # Change this line
	print("[Movement System] Moving character from", old_position, "to", event.new_position)
	print("[Movement System] Moves left after this move:", new_moves_left)
	
	return {
		"type": "move_character",
		"character_id": event.character_id,
		"old_position": old_position,
		"new_position": event.new_position,
		"moves_left": new_moves_left  # Now it should keep track properly
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
