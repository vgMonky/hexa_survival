# In game/map/map.gd

extends Node
class_name Map

var hex_tiles: Dictionary = {}  # Dictionary to store HexTiles by their position

func _init(h: int, w: int):
	# Initialize hex tiles for the map and store them in the dictionary
	for y in range(h):
		for x in range(w):
			var position = Vector2(x, y)  # Coordinate of the hex tile

			# Randomly pick a biome from the predefined biomes
			var biome_data = get_random_biome()

			# Create new HexTile with the corresponding biome
			var tile = HexTile.new(position, biome_data["biome_name"], biome_data["color"], biome_data["resources"])

			hex_tiles[position] = tile  # Store the tile in the dictionary with its position as the key
	
	name = "Map"  # Set the name to identify the node
	print("Map created with dimensions:", h, "x", w)

# Example function to get a tile at a specific position
func get_tile_at_position(position: Vector2) -> HexTile:
	if hex_tiles.has(position):
		return hex_tiles[position]  # Return the HexTile at the specified position
	return null  # Return null if the tile is not found

# Function to get a random biome from BiomeTypes
func get_random_biome() -> Dictionary:
	var random_index = randi() % BiomeTypes.ALL_BIOMES.size()
	return BiomeTypes.ALL_BIOMES[random_index]
