extends Node2D

func _ready():
	# Create an instance of StateManager
	var state_manager = StateManager.new()
	
	# Simulate a map creation event
	var map_event = MapEvent.new(10, 15) # Map with height 10 and width 15
	state_manager.change_game_state(map_event)
	
	# Print the current game state
	state_manager.print_state()
