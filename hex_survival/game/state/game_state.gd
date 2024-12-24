# game/state/game_state.gd
class_name GameState
extends Reference

# GameState represents the complete state of the game at any given moment.
# It is designed to be immutable during each frame and only modified through
# the state manager using events.
#
# GameState's sole responsibility is now:
# - Store game data (map, entities, resources, etc.)

# Raw game data
var map_data: Dictionary
var characters: Dictionary = {}  # Add this line

func _init(width: int = 0, height: int = 0) -> void:
	if width > 0 and height > 0:
		var map = Map.new(width, height)
		map.initialize()
		map_data = map.to_dict()

func duplicate() -> Reference:
	var new_state = get_script().new()
	new_state.map_data = map_data.duplicate(true)
	new_state.characters = characters.duplicate(true)  # Add this line
	return new_state
