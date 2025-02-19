# In map/biome_types.gd

extends Node
class_name BiomeTypes

# Predefined biome data
const WOODS = {
	"biome_name": "Woods",
	"color": Color(0.1, 0.5, 0.1),  # Dark green
	"resources": {
		"wood": 0.6  # 60% chance to have wood
	},
	"walkable": true  # Woods are walkable
}

const DESERT = {
	"biome_name": "Desert",
	"color": Color(1.0, 1.0, 0.0),  # Yellow
	"resources": {
		"sand": 0.8  # 80% chance to have sand
	},
	"walkable": true  # Desert is walkable
}

const MOUNTAIN = {
	"biome_name": "Mountain",
	"color": Color(0.6, 0.3, 0.1),  # Brown
	"resources": {
		"stone": 0.7,  # 70% chance to have stone
		"iron": 0.3   # 30% chance to have iron
	},
	"walkable": true
}

const WATER = {
	"biome_name": "Water",
	"color": Color(0.0, 0.0, 1.0),  # Blue
	"resources": {
		"fish": 0.5  # 50% chance to have fish
	},
	"walkable": false  # Water is not walkable
}

# Add more biomes as needed
const ALL_BIOMES = [WOODS, DESERT, MOUNTAIN, WATER]
