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


static func is_position_occupied_by_character(state: GameState, position: Vector2) -> bool:
	for character in state.characters.values():
		# Retrieve the position from the character's components as a dictionary
		var character_position_dict = character.components.get("position", {}).get("position", {})

		# Convert character position from dictionary to Vector2
		var character_position = Vector2(character_position_dict.get("x", 0), character_position_dict.get("y", 0))
		
		# Print the current character position and the passed position for debugging
		#print("Character Position: ", character_position)
		#print("Given Position: ", position)
		
		# Compare the actual position (Vector2) with the given position
		if character_position == position:
			return true
	return false



# Returns true if the hex at position is walkable (not occupied by a character)
static func is_hex_walkable(state: GameState, position: Vector2) -> bool:
	# Check if there is any character at this position
	if is_position_occupied_by_character(state, position):
		return false  # Position is not walkable if occupied by a character

	# Check if the biome is walkable
	var hex = get_hex_at(state, position)
	return hex.get("biome_data", {}).get("walkable", false)
	
# Returns the resources available at a position
static func get_hex_resources(state: GameState, position: Vector2) -> Dictionary:
	var hex = get_hex_at(state, position)
	return hex.get("biome_data", {}).get("resources", {})
