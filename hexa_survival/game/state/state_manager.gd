extends Node

class_name StateManager

signal game_state_changed(new_state)

var _current_game_state: GameState = null

func _init():
	_current_game_state = GameState.new()
	print("StateManager ready: Initial game state created")

# Method to change the game state
func change_game_state(event: Event):
	if _current_game_state == null:
		print("Error: No current game state to change")
		return
	
	# Apply the event directly to the current game state
	if event is Event:
		_current_game_state = event.apply_to_game_state(_current_game_state)
	else:
		print("Error: Invalid event provided:", event)
		return
	
	# Validate the new game state
	if not _current_game_state is GameState:
		print("Error: The new game state is not a valid GameState")
		return
	
	# Emit the signal that the game state has changed
	print("Game state successfully updated based on event:", event)
	emit_signal("game_state_changed", _current_game_state)
