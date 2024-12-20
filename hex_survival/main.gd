extends Node

var state_manager: StateManager
var map_view_container: MapViewContainer

func _ready() -> void:
	print("\n=== Game Starting ===")
	
	state_manager = StateManager.new()
	add_child(state_manager)
	state_manager.initialize(6, 8)
	
	map_view_container = MapViewContainer.new(state_manager)
	add_child(map_view_container)
	
	# Create info panel
	var info_panel = GameInfoPanel.new(state_manager)
	add_child(info_panel)
	info_panel.rect_position = Vector2(50, 50)  # Set initial position

	# Print sample of hex information
	print("\nSample of hex tiles:")
	print_hex_at(Vector2(0, 0))
	print_hex_at(Vector2(3, 2))
	print_hex_at(Vector2(6, 4))
	
	state_manager.apply_state_change(MapEvents.transform_biome(Vector2(0, 0), "WOODS"))

	print_hex_at(Vector2(0, 0))
		
func print_hex_at(pos: Vector2) -> void:
	var hex = state_manager.current_state.get_hex_at(pos)
	if hex:
		print("Hex(%s,%s): %s | Walkable: %s | Resources: %s" % [
			pos.x, pos.y,
			hex.biome,
			hex.biome_data.walkable,
			hex.biome_data.resources
		])
	else: print("no hex at %s" % [pos])
