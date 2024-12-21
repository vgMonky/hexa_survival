class_name BiomeTypes
extends Reference

const TYPES = {
	"WOODS": {
		"color": Color.darkgreen,
		"walkable": true,
		"spawn_chance": 0.6,  #chance to spawn
		"resources": {
			"wood": 0.9  # 90% chance
		}
	},
	"CAVE": {
		"color": Color.lightslategray,
		"walkable": true,
		"spawn_chance": 0.2,  # chance to spawn
		"resources": {
			"rock": 0.9,  # 90% chance
			"iron": 0.2   # 20% chance
		}
	},
	"DESERT": {
		"color": Color.goldenrod,
		"walkable": true,
		"spawn_chance": 0.3, 
		"resources": {}  # no resources
	},
	"WATER": {
		"color": Color.darkblue,
		"walkable": false,
		"spawn_chance": 0.3, 
		"resources": {}  # no resources
	}
}

# Helper function to get random biome type using spawn chances
static func get_random_type() -> String:
	var total_chance := 0.0
	for type in TYPES:
		total_chance += TYPES[type].spawn_chance
	
	var roll = randf() * total_chance
	var current_total := 0.0
	
	for type in TYPES:
		current_total += TYPES[type].spawn_chance
		if roll <= current_total:
			return type
	
	return "DESERT"  # Fallback

# Helper function to get biome data
static func get_data(biome_type: String) -> Dictionary:
	return TYPES.get(biome_type, TYPES.DESERT)
