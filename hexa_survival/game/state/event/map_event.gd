extends Event
class_name MapEvent

var map_h: int
var map_w: int

func _init(h: int, w: int):
	map_h = h
	map_w = w

func apply_to_game_state(game_state: GameState) -> GameState:
	if game_state.game_map:
		print("MapEvent: Resetting the game state")
		# Create a new GameState instance (reset the state)
		game_state = GameState.new()

	# Create a new Map reference with the given dimensions
	print("MapEvent: Adding a new map to the game state")
	var map = Map.new(map_h, map_w)

	# Set the new map in the game state
	game_state.set_map(map)

	return game_state
