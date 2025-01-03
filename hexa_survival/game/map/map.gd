extends Reference
class_name Map

var hex_tiles: Dictionary = {}  # Dictionary to store HexTiles by their position

func _init(h: int, w: int):
	for y in range(h):
		for x in range(w):
			var position = Vector2(x, y)
			var biome_data = get_random_biome()
			var tile = HexTileEntity.new(position, biome_data["biome_name"], biome_data["color"], biome_data["resources"], biome_data["walkable"])
			hex_tiles[position] = tile  # Store tile in dictionary

	print("Map created with dimensions:", h, "x", w)

func get_tile_at_position(position: Vector2) -> HexTileEntity:
	if hex_tiles.has(position):
		return hex_tiles[position]
	return null

func get_random_biome() -> Dictionary:
	var random_index = randi() % BiomeTypes.ALL_BIOMES.size()
	return BiomeTypes.ALL_BIOMES[random_index]
