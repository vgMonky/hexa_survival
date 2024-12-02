# map_events.gd
class_name MapEvents
extends Reference

class SetBiomesHandler extends Reference:
	func process(state: GameState) -> Dictionary:
		var new_hexes = {}
		for pos in state.map_data.hexes:
			var hex_data = state.map_data.hexes[pos].duplicate(true)
			var biome_type = BiomeTypes.get_random_type()
			hex_data.biome = biome_type
			hex_data.biome_data = BiomeTypes.get_data(biome_type)
			new_hexes[pos] = hex_data
		
		state.map_data.hexes = new_hexes
		return {
			"type": "set_biomes",
			"hexes": new_hexes
		}

class TransformBiomeHandler extends Reference:
	var position: Vector2
	var new_biome: String
	
	func _init(pos: Vector2, biome: String):
		position = pos
		new_biome = biome
	
	func process(state: GameState) -> Dictionary:
		if not state.map_data.hexes.has(position):
			return {}  # Return empty if position invalid
			
		var hex_data = state.map_data.hexes[position].duplicate(true)
		hex_data.biome = new_biome
		hex_data.biome_data = BiomeTypes.get_data(new_biome)
		state.map_data.hexes[position] = hex_data
		
		return {
			"type": "transform_biome",
			"position": position,
			"old_biome": state.map_data.hexes[position].biome,
			"new_biome": new_biome
		}

static func set_biomes() -> StateChange:
	var handler = SetBiomesHandler.new()
	return StateChange.new(handler, "process")

static func transform_biome(pos: Vector2, new_biome: String) -> StateChange:
	var handler = TransformBiomeHandler.new(pos, new_biome)
	return StateChange.new(handler, "process")
