# game/queries/map_query.gd
class_name MapQuery
extends Reference

# Returns hex data at given position or empty dict if not found
static func get_hex_at(state: GameState, position: Vector2) -> Dictionary:
	return state.map_data.hexes.get(position, {})

# Returns the size of the map as Vector2(width, height)
static func get_map_size(state: GameState) -> Vector2:
	return Vector2(
		state.map_data.width,
		state.map_data.height
	)

# Returns true if the position exists in the map
static func has_hex_at(state: GameState, position: Vector2) -> bool:
	return state.map_data.hexes.has(position)

# Returns all positions that exist in the map
static func get_all_positions(state: GameState) -> Array:
	return state.map_data.hexes.keys()

# Returns hex positions matching a specific biome type
static func get_positions_by_biome(state: GameState, biome_type: String) -> Array:
	var positions = []
	for pos in state.map_data.hexes:
		if state.map_data.hexes[pos].biome == biome_type:
			positions.append(pos)
	return positions

# Returns true if the hex at position is walkable
static func is_hex_walkable(state: GameState, position: Vector2) -> bool:
	var hex = get_hex_at(state, position)
	return hex.get("biome_data", {}).get("walkable", false)

# Returns the resources available at a position
static func get_hex_resources(state: GameState, position: Vector2) -> Dictionary:
	var hex = get_hex_at(state, position)
	return hex.get("biome_data", {}).get("resources", {})
