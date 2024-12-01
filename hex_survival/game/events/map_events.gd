class_name MapEvents
extends Reference

const SET_BIOMES = "set_biomes"

static func set_biomes() -> Dictionary:
	return {
		"type": SET_BIOMES
	}

static func process_set_biomes(state: GameState) -> Dictionary:
	var new_hexes = {}
	for pos in state.map_data.hexes:
		var hex_data = state.map_data.hexes[pos].duplicate(true)
		var biome_type = BiomeTypes.get_random_type()
		hex_data.biome = biome_type
		hex_data.biome_data = BiomeTypes.get_data(biome_type)
		new_hexes[pos] = hex_data
	
	return {
		"type": SET_BIOMES,
		"hexes": new_hexes
	}
