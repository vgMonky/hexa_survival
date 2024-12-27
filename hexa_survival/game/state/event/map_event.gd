# MapEvent.gd
extends Event
class_name MapEvent

var map_h: int
var map_w: int

func _init(h: int, w: int):
	map_h = h
	map_w = w

func apply_to_game_state(game_state: GameState) -> GameState:
	print("MapEvent: Adding a map to the game state")

	# Create a new Map node
	var map = Map.new(map_h, map_w)  # This should be recognized as Map
	game_state.add_child(map)
	return game_state
