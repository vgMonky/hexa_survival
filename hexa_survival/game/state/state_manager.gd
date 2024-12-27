extends Node

class_name StateManager

var _current_game_state = null

func _init():
	_current_game_state = GameState.new()
	print("StateManager ready: Initial game state created")

func change_game_state(event: Event):
	# Create a duplicate of the current game state using the custom copy method
	var new_game_state = _current_game_state.copy()
	
	# Apply the event to the new game state
	if event is Event:
		new_game_state = event.apply_to_game_state(new_game_state)
	else:
		print("Error: Invalid event provided:", event)
		return
	
	# Check if the result is still a valid GameState
	if not new_game_state is GameState:
		print("Error: The new game state is not a valid GameState")
		return
	
	# Update the current game state and print success message
	_current_game_state = new_game_state
	print("Game state successfully updated based on event:", event)

# Function to print the current game state
func print_state():
	print("Current Game State:")
	for child in _current_game_state.get_children():
		print("  Child node:", child.name)
