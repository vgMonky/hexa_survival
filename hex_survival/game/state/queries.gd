# state/queries.gd
class_name StateQueries
extends Reference

var state_manager

func _init(sm) -> void: 
	state_manager = sm
	print("State queries initialized")

func get_hex_at(position: Vector2) -> Dictionary:
	return state_manager.current_state.map_data.hexes.get(position, {})

func get_map_size() -> Vector2:
	return Vector2(
		state_manager.current_state.map_data.width,
		state_manager.current_state.map_data.height
	)
