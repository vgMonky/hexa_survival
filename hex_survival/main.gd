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

	
	# Print sample of hex information
	print("\nSample of hex tiles:")
	print_hex_at(Vector2(0, 0))
	print_hex_at(Vector2(3, 2))
	print_hex_at(Vector2(6, 4))

func print_hex_at(pos: Vector2) -> void:
	var hex = state_manager.queries.get_hex_at(pos)
	if hex:
		print("Hex(%s,%s): %s | Walkable: %s | Resources: %s" % [
			pos.x, pos.y,
			hex.biome,
			hex.biome_data.walkable,
			hex.biome_data.resources
		])
	else: print("no hex at %s" % [pos])
