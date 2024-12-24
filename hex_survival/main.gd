extends Node

var state_manager: StateManager
var map_view_container: MapViewContainer
var control_panel: GameControlPanel
var info_panel: GameInfoPanel
var char_panel: CharacterControlPanel

func _ready() -> void:
	print("\n=== Game Starting ===")
	
	# Initialize state manager with a small default map
	state_manager = StateManager.new()
	add_child(state_manager)
	state_manager.initialize(5, 5)  # Start with a 5x5 map by default
	
	# Create char control panel
	char_panel = CharacterControlPanel.new(state_manager)
	add_child(char_panel)
	
	# Create control panel
	control_panel = GameControlPanel.new(state_manager)
	add_child(control_panel)
	control_panel.rect_position = Vector2(50, 50)
	
	# Create map view container
	map_view_container = MapViewContainer.new(state_manager)
	add_child(map_view_container)
	
	# Create info panel
	info_panel = GameInfoPanel.new(state_manager)
	add_child(info_panel)
	info_panel.rect_position = Vector2(300, 50)
	
	print("Initial setup complete")
	
	
	# Print sample of hex information and transformation
	print("\nSample of hex tiles:")
	print_hex_at(Vector2(0, 0))
	state_manager.apply_state_change(MapEvents.transform_biome(Vector2(0, 0), "WATER"))
	print_hex_at(Vector2(0, 0))
	
	
	state_manager.apply_state_change(CharacterEvents.create_character(Vector2(4, 4)))
	print("Characters in state:", state_manager.current_state.characters)
	# Query all characters
	#var all_characters = Query.get_char().get_all_characters(state_manager.current_state)
	#print("All characters:", all_characters)


func print_hex_at(pos: Vector2) -> void:
	var hex = Query.get_map().get_hex_at(state_manager.current_state, pos)
	if hex:
		print("Hex(%s,%s): %s | Walkable: %s | Resources: %s" % [
			pos.x, pos.y,
			hex.biome,
			hex.biome_data.walkable,
			hex.biome_data.resources
		])
	else: print("no hex at %s" % [pos])
