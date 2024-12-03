# game/systems/map_system.gd
class_name MapSystem
extends Reference

# Pure function to generate random biomes for all hexes
static func generate_biome_distribution(hexes: Dictionary) -> Dictionary:
	var new_hexes = {}
	for pos in hexes:
		var hex_data = hexes[pos].duplicate(true)
		var biome_type = BiomeTypes.get_random_type()
		new_hexes[pos] = create_hex_with_biome(hex_data, biome_type)
	return new_hexes

# Pure function to validate and create a hex with new biome
static func create_hex_with_biome(hex_data: Dictionary, biome_type: String) -> Dictionary:
	var new_hex = hex_data.duplicate(true)
	new_hex.biome = biome_type
	new_hex.biome_data = BiomeTypes.get_data(biome_type)
	return new_hex

# Pure function to check if position exists in the map
static func can_transform_biome(hexes: Dictionary, position: Vector2) -> bool:
	return hexes.has(position)
