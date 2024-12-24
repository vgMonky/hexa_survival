# game/view/map/map_view.gd
class_name MapView
extends Node2D

var state_manager: StateManager
var hex_views = {}  # Dictionary of hex views
var character_views = {}  # Dictionary of character views

func _init(sm: StateManager) -> void:
	state_manager = sm
	# Connect to state changes
	state_manager.connect("state_updated", self, "_on_state_updated")
	# Initial draw
	update_map()

func update_map() -> void:
	# Clear existing hexes and character views
	for hex in hex_views.values():
		hex.queue_free()
	hex_views.clear()

	for character_view in character_views.values():
		character_view.queue_free()
	character_views.clear()
	
	# Create new hex views
	var map_size = Query.get_map().get_map_size(state_manager.current_state)
	for x in range(map_size.x):
		for y in range(map_size.y):
			var grid_pos = Vector2(x, y)
			var hex_data = Query.get_map().get_hex_at(state_manager.current_state ,grid_pos)
			var hex_view = HexView.new(grid_pos, hex_data)
			add_child(hex_view)
			hex_views[grid_pos] = hex_view

	# Create new character views
	for character in state_manager.current_state.characters.values():
		# Retrieve the position correctly as a Dictionary
		var position_data = character.components.get("position", {}).get("position", {})
		# Convert position data (x, y) into Vector2
		var position = Vector2(position_data.get("x", 0), position_data.get("y", 0))
		
		var character_id = character.id
		var character_color = Color(3, 0, 0) # Random color for now
		
		# Create character view
		var character_view = CharacterView.new(character_id, position, character_color)
		add_child(character_view)
		character_views[position] = character_view

func _on_state_updated() -> void:
	update_map()

func get_map_size() -> Vector2:
	var map_size = Query.get_map().get_map_size(state_manager.current_state)
	var hex_size = HexView.HEX_SIZE
	var map_width = map_size.x * hex_size * 1.5
	var map_height = map_size.y * hex_size * sqrt(3)
	return Vector2(map_width, map_height)
