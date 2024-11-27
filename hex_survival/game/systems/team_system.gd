# game/systems/team_system.gd
class_name TeamSystem
extends BaseSystem

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"add_team":
			return _validate_and_create_team(current_state, event)
	return {}

func _validate_and_create_team(state: GameState, event: Dictionary) -> Dictionary:
	if state.teams.team_data.has(event.team_name):
		push_error("Team name already exists")
		return {}
	
	for team_data in state.teams.team_data.values():
		if team_data.color == event.team_color:
			push_error("Team color already in use")
			return {}
	
	return {
		"type": "add_team",
		"team_name": event.team_name,
		"team_color": event.team_color
	}
