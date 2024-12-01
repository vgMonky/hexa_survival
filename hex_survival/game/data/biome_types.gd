# game/data/biome_types.gd
class_name BiomeTypes
extends Reference

const TYPES = {
	"WOODS": {
		"color": Color.darkgreen,
		"walkable": true,
		"resources": {
			"wood": 0.9  # 90% chance
		}
	},
	"CAVE": {
		"color": Color.lightslategray,
		"walkable": true,
		"resources": {
			"rock": 0.9,  # 90% chance
			"iron": 0.2   # 20% chance
		}
	},
	"DESERT": {
		"color": Color.goldenrod,
		"walkable": true,
		"resources": {}  # no resources
	},
	"WATER": {
		"color": Color.darkblue,
		"walkable": false,
		"resources": {}  # no resources
	}
}

# Helper function to get random biome type
static func get_random_type() -> String:
	var types = TYPES.keys()
	return types[randi() % types.size()]

# Helper function to get biome data
static func get_data(biome_type: String) -> Dictionary:
	return TYPES.get(biome_type, TYPES.DESERT)
