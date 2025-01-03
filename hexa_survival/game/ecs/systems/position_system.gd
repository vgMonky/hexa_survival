extends System
class_name PositionSystem

# Validate a position in the game state
func is_valid_position(game_state: GameState, position: Vector2) -> bool:
	# Check if the position is already occupied by an entity
	for entity in game_state.game_entities:
		var position_component: PositionComponent = _get_component(entity, "PositionComponent")
		if position_component and position_component.position == position:
			print("PositionSystem: Position ", position, " is already occupied by entity: ", entity)
			return false
	
	# Check if the hex tile at the position exists and is walkable
	var hex_tile = _get_hex_tile_at_position(game_state, position)
	if hex_tile == null:
		print("PositionSystem: No hex tile found at position ", position)
		return false
	
	var biome_component: BiomeComponent = _get_component(hex_tile, "BiomeComponent")
	if biome_component and not biome_component.walkable:
		print("PositionSystem: Hex tile at position ", position, " is not walkable.")
		return false
	
	return true

# Helper: Get the HexTileEntity at a position
func _get_hex_tile_at_position(game_state: GameState, position: Vector2) -> Entity:
	if game_state.game_map and game_state.game_map.hex_tiles.has(position):
		return game_state.game_map.hex_tiles[position]
	return null

# Helper: Get a specific component from an entity
func _get_component(entity: Entity, component_name: String) -> Component:
	if entity.components.has(component_name):
		return entity.components[component_name]
	return null
