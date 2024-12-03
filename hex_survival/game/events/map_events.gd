# game/events/map_events.gd
class_name MapEvents
extends Reference

class SetBiomesHandler extends Reference:
	func process(state: GameState) -> Dictionary:
		var new_hexes = MapSystem.generate_biome_distribution(state.map_data.hexes)
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
		# Use system to validate transform
		if not MapSystem.can_transform_biome(state.map_data.hexes, position):
			return {}  # Return empty if position invalid
			
		# Use system to create new hex data
		var hex_data = state.map_data.hexes[position]
		var new_hex = MapSystem.create_hex_with_biome(hex_data, new_biome)
		state.map_data.hexes[position] = new_hex
		
		return {
			"type": "transform_biome",
			"position": position,
			"old_biome": hex_data.biome,
			"new_biome": new_biome
		}

static func set_biomes() -> StateChange:
	var handler = SetBiomesHandler.new()
	return StateChange.new(handler, "process")

static func transform_biome(pos: Vector2, new_biome: String) -> StateChange:
	var handler = TransformBiomeHandler.new(pos, new_biome)
	return StateChange.new(handler, "process")
