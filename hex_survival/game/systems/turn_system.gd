# game/systems/turn_system.gd
class_name TurnSystem
extends BaseSystem

const ACTIONS_PER_TURN = 1  # For now, just 1 action per turn

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"initialize_turn_order":
			return _initialize_turn_order(current_state)
		"next_turn":
			return _process_next_turn(current_state)
	return {}

func _initialize_turn_order(state: GameState) -> Dictionary:
	var all_characters = []
	
	# Collect all characters from all teams
	for team_name in state.teams.members:
		all_characters.append_array(state.teams.members[team_name])
	
	# Randomize initial turn order
	randomize()
	all_characters.shuffle()
	
	return {
		"type": "initialize_turn_order",
		"turn_order": all_characters,
		"current_turn_index": 0,
		"current_round": 1,
		"actions_left": ACTIONS_PER_TURN
	}

func _process_next_turn(state: GameState) -> Dictionary:
	var new_turn_index = state.turn_data.current_turn_index + 1
	var new_round = state.turn_data.current_round
	
	# If we've gone through all characters, start a new round
	if new_turn_index >= state.turn_data.turn_order.size():
		new_turn_index = 0
		new_round += 1
	
	return {
		"type": "next_turn",
		"current_turn_index": new_turn_index,
		"current_round": new_round,
		"moves_left": 1  # Reset moves at start of turn
	}

func get_current_character(state: GameState) -> String:
	if state.turn_data.turn_order.empty():
		return ""
	return state.turn_data.turn_order[state.turn_data.current_turn_index]
