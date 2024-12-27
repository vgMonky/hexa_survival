extends Node

class_name StateManager

# Declare the signal
signal game_state_changed(new_state)

var _current_game_state: GameState = null

func _init():
	_current_game_state = GameState.new()
	print("StateManager ready: Initial game state created")

func duplicate_state(state: GameState) -> GameState:
	if state == null:
		print("Error: No game state to duplicate")
		return null

	var new_state = GameState.new()  # Create a new instance of GameState
	# Duplicate all child nodes
	for child in state.get_children():
		if child.has_method("duplicate"):  # Check if the child has a duplicate method
			var duplicate_child = child.duplicate(true)
			if duplicate_child == null:
				print("Error: Failed to duplicate child:", child)
			else:
				print("Successfully duplicated child:", child, "->", duplicate_child)
				new_state.add_child(duplicate_child)
		else:
			print("Warning: Child node", child.name, "does not have a 'duplicate' method and will not be duplicated.")

	return new_state


# Method to change the game state
func change_game_state(event: Event):
	if _current_game_state == null:
		print("Error: No current game state to change")
		return

	# Duplicate the current game state
	var new_game_state = duplicate_state(_current_game_state)
	if new_game_state == null:
		print("Error: Failed to duplicate the game state")
		return
	
	# Apply the event to the new game state
	if event is Event:
		new_game_state = event.apply_to_game_state(new_game_state)
	else:
		print("Error: Invalid event provided:", event)
		return
	
	# Validate the new game state
	if not new_game_state is GameState:
		print("Error: The new game state is not a valid GameState")
		return
	
	# Update the current game state and emit the signal
	_current_game_state = new_game_state
	print("Game state successfully updated based on event:", event)
	emit_signal("game_state_changed", _current_game_state)
