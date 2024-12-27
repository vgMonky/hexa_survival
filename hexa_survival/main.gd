extends Node2D

func _ready():
	# Create an instance of StateManager
	var state_manager = StateManager.new()
	
	# Connect the signal `game_state_changed` to `_on_game_state_changed`
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	# Simulate a map creation event
	var map_event = MapEvent.new(10, 15) # Map with height 10 and width 15
	state_manager.change_game_state(map_event)
	var char_event = CharacterEvent.new("Jhon")
	state_manager.change_game_state(char_event)
# Function to handle the game state change signal
func _on_game_state_changed(new_state):
	print("Signal received: Game state has changed!")
	# Print the updated game state
	for child in new_state.get_children():
		print("  Child node:", child.name)
