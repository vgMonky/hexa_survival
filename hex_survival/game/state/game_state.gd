# game_state.gd

# GameState represents the complete state of the game at any given moment.
# It is designed to be immutable during each frame and only modified through
# the state manager using events.
#
# GameState has two main responsibilities:
# 1. Store game data (map, entities, resources, etc.)
# 2. Provide safe query methods to access this data
#
# Query methods:
# - Are read-only functions that provide safe access to state data
# - Handle edge cases and provide sensible defaults
# - Make data access consistent across the game
# - Can combine or format data for common use cases
class_name GameState
extends Reference

# Raw game data
var map_data: Dictionary

func _init(width: int = 0, height: int = 0) -> void:
	if width > 0 and height > 0:
		var map = Map.new(width, height)
		map.initialize()
		map_data = map.to_dict()

# Creates a deep copy of the state for safe modification
func duplicate() -> Reference:
	var new_state = get_script().new()
	new_state.map_data = map_data.duplicate(true)
	return new_state

# Query Methods

# Returns hex data at given position or empty dict if not found
func get_hex_at(position: Vector2) -> Dictionary:
	return map_data.hexes.get(position, {})

# Returns the size of the map as Vector2(width, height)
func get_map_size() -> Vector2:
	return Vector2(
		map_data.width,
		map_data.height
	)

# Returns true if the position exists in the map
func has_hex_at(position: Vector2) -> bool:
	return map_data.hexes.has(position)

# Returns all positions that exist in the map
func get_all_positions() -> Array:
	return map_data.hexes.keys()

# Returns hex positions matching a specific biome type
func get_positions_by_biome(biome_type: String) -> Array:
	var positions = []
	for pos in map_data.hexes:
		if map_data.hexes[pos].biome == biome_type:
			positions.append(pos)
	return positions

# Returns true if the hex at position is walkable
func is_hex_walkable(position: Vector2) -> bool:
	var hex = get_hex_at(position)
	return hex.get("biome_data", {}).get("walkable", false)

# Returns the resources available at a position
func get_hex_resources(position: Vector2) -> Dictionary:
	var hex = get_hex_at(position)
	return hex.get("biome_data", {}).get("resources", {})
