extends Node2D

func _ready():
	# Create an instance of StateManager
	var state_manager = StateManager.new()
	var state_manager_two = StateManager.new()
	
	# Simulate an event
	var test_event = Event.new()
	state_manager.change_game_state(test_event)
	
	# Simulate a query
	var test_query = Query.new()
	var result = state_manager.query_game_state(test_query)
	print("Query result:", result)
