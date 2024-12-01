class_name MapView
extends Node2D

var state_manager: StateManager
var hex_views = {}  # Dictionary of hex views

func _init(sm: StateManager) -> void:
	state_manager = sm
	# Connect to state changes
# warning-ignore:return_value_discarded
	state_manager.connect("state_updated", self, "_on_state_updated")
	# Initial draw
	update_map()

func update_map() -> void:
	# Clear existing hexes
	for hex in hex_views.values():
		hex.queue_free()
	hex_views.clear()
	
	# Create new hex views
	var map_size = state_manager.queries.get_map_size()
	for x in range(map_size.x):
		for y in range(map_size.y):
			var grid_pos = Vector2(x, y)
			var hex_data = state_manager.queries.get_hex_at(grid_pos)
			var hex_view = HexView.new(grid_pos, hex_data)
			add_child(hex_view)
			hex_views[grid_pos] = hex_view

func _on_state_updated() -> void:
	update_map()
	
func get_map_size() -> Vector2:
	var map_size = state_manager.queries.get_map_size()
	var hex_size = HexView.HEX_SIZE
	var map_width = map_size.x * hex_size * 1.5
	var map_height = map_size.y * hex_size * sqrt(3)
	return Vector2(map_width, map_height)
