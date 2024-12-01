# game/state/game_state.gd
class_name GameState
extends Reference

var map_data: Dictionary

func _init(width: int, height: int) -> void:
	var map = Map.new(width, height)
	map.initialize()
	map_data = map.to_dict()
