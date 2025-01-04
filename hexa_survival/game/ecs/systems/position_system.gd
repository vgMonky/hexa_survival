extends System
class_name PositionSystem

# Directions for a hexagonal grid (pointy top orientation)
const DIRECTION_OFFSETS = [
	Vector2(1, 0),   # East
	Vector2(0, -1),  # Northeast
	Vector2(-1, -1), # Northwest
	Vector2(-1, 0),  # West
	Vector2(0, 1),   # Southwest
	Vector2(1, 1)    # Southeast
]

# Calculate adjacent position based on direction
static func get_adjacent_position(position: Vector2, direction: int) -> Vector2:
	# Wrap direction between 0 and 5
	direction = direction % 6
	if direction < 0:
		direction += 6
	return position + DIRECTION_OFFSETS[direction]

# Check if a hex tile exists (ignores occupation and walkability)
static func hex_tile_exists(game_state: GameState, position: Vector2) -> bool:
	return _get_hex_tile_at_position(game_state, position) != null

# Check if a hex tile is valid (including walkability and occupation checks)
static func is_valid_position(game_state: GameState, position: Vector2) -> bool:
	# Check if the hex tile exists
	var hex_tile = _get_hex_tile_at_position(game_state, position)
	if hex_tile == null:
		return false
	
	# Check if the hex tile is walkable
	var biome_component: BiomeComponent = hex_tile.get_component("BiomeComponent")
	if biome_component and not biome_component.walkable:
		return false

	# Check if the position is already occupied by an entity
	for entity in game_state.game_entities:
		var position_component: PositionComponent = entity.get_component("PositionComponent")
		if position_component and position_component.position == position:
			return false

	return true

# Helper: Get the HexTileEntity at a position
static func _get_hex_tile_at_position(game_state: GameState, position: Vector2) -> Entity:
	if game_state.game_map and game_state.game_map.hex_tiles.has(position):
		return game_state.game_map.hex_tiles[position]
	return null
