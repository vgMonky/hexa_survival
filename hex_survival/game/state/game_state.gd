# game_state.gd
class_name GameState
extends Reference

var map_data: Dictionary

func _init(width: int = 0, height: int = 0) -> void:
	if width > 0 and height > 0:
		var map = Map.new(width, height)
		map.initialize()
		map_data = map.to_dict()

func duplicate() -> Reference:
	var new_state = get_script().new()  # Creates new instance of same class
	new_state.map_data = map_data.duplicate(true)
	return new_state
