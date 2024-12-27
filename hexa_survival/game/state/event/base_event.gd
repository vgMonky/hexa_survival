extends Reference
class_name Event

# A method to modify a game state, to be overridden by subclasses
func apply_to_game_state(game_state: GameState) -> GameState:
	print("Event applied to game state")
	return game_state
