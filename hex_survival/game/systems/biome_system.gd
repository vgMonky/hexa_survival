# game/systems/biome_system.gd
class_name BiomeSystem
extends BaseSystem

const BIOME_TYPES = {
	"WOODS": {
		"color": Color.green,
		"walkable": true,
		"resources": {
			"wood": 0.9  # 90% chance
		}
	},
	"CAVE": {
		"color": Color.gray,
		"walkable": true,
		"resources": {
			"rock": 0.9,  # 90% chance
			"iron": 0.2   # 20% chance
		}
	},
	"DESERT": {
		"color": Color.yellow,
		"walkable": true,
		"resources": {}  # no resources
	},
	"WATER": {
		"color": Color.blue,
		"walkable": false,
		"resources": {}  # no resources
	}
}

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"generate_map":
			return _apply_biomes(current_state, event)
	return {}

func _apply_biomes(_state: GameState, event: Dictionary) -> Dictionary:
	var hexes = event.hexes
	print("Applying biomes to map...")
	
	var biome_counts = {}
	# Apply biomes to each hex
	for hex in hexes.values():
		var biome_type = _get_random_biome()
		hex.biome = biome_type
		hex.biome_data = BIOME_TYPES[biome_type]
		
		if not biome_counts.has(biome_type):
			biome_counts[biome_type] = 0
		biome_counts[biome_type] += 1
	
	print("Biome distribution: ", biome_counts)
	return {
		"type": "generate_map",
		"width": event.width,
		"height": event.height,
		"hexes": hexes
	}

func _get_random_biome() -> String:
	var biomes = BIOME_TYPES.keys()
	return biomes[randi() % biomes.size()]
