extends Node

class_name StateManager

var _current_game = null

func _ready():
	_current_game = GameState.new()
	print("StateManager ready: Initial game state created")

func change_game_state(event):
	print("Changing game state based on event:", event)
	# You can implement logic here to update the game state based on the event

func query_game_state(query):
	print("Querying game state with:", query)
	# For now, just return the _current_game as a placeholder
	return _current_game
