# game/systems/movement_system.gd
class_name MovementSystem
extends BaseSystem

const MAX_MOVE = 1

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"get_valid_moves":
			return _get_valid_moves(current_state, event.character_id)
		"move_character":
			return _validate_and_move_character(current_state, event)
	return {}

func _get_valid_moves(state: GameState, character_id: String) -> Dictionary:
	if state.turn_data.moves_left <= 0:
		return {
			"type": "valid_moves",
			"character_id": character_id,
			"valid_positions": []
		}
	
	var character = state.entities.characters[character_id]
	var current_pos = character.position
	var valid_moves = []
	
	for direction in _get_adjacent_offsets():
		var target_pos = current_pos + direction
		if _is_valid_move(state, target_pos):
			valid_moves.append(target_pos)
	
	return {
		"type": "valid_moves",
		"character_id": character_id,
		"valid_positions": valid_moves
	}

func _validate_and_move_character(state: GameState, event: Dictionary) -> Dictionary:
	# Check if we have moves left
	if state.turn_data.moves_left <= 0:
		print("[Move] No moves left this turn")
		return {}

	var valid_moves = _get_valid_moves(state, event.character_id)
	
	if not event.new_position in valid_moves.valid_positions:
		print("[Move] Invalid position: ", event.new_position)
		return {}
		
	var old_position = state.entities.characters[event.character_id].position
	print("[Move] Moving from ", old_position, " to ", event.new_position)
	
	return {
		"type": "move_character",
		"character_id": event.character_id,
		"old_position": old_position,
		"new_position": event.new_position,
		"moves_left": 0  # Set to 0 after moving
	}
func _get_adjacent_offsets() -> Array:
	return [
		Vector2(1, 0),   # right
		Vector2(1, -1),  # up-right
		Vector2(0, -1),  # up-left
		Vector2(-1, 0),  # left
		Vector2(-1, 1),  # down-left
		Vector2(0, 1)    # down-right
	]

func _is_valid_move(state: GameState, pos: Vector2) -> bool:
	if not state.map_data.hexes.has(pos):
		return false
	
	var hex_data = state.map_data.hexes[pos]
	
	if not hex_data.biome_data.walkable:
		return false
	
	if hex_data.entity != null:
		return false
		
	return true
