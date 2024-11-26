class_name BiomeData
extends Node

static func create_woods() -> Dictionary:
	return {
		"biome_name": "Woods",
		"color": Color.green,
		"walkable": true,
		"resources": {
			"wood": 0.9  # 90% chance
		}
	}

static func create_cave() -> Dictionary:
	return {
		"biome_name": "Cave",
		"color": Color.gray,
		"walkable": true,
		"resources": {
			"rock": 0.9,  # 90% chance
			"iron": 0.2   # 20% chance
		}
	}

static func create_water() -> Dictionary:
	return {
		"biome_name": "Water",
		"color": Color.blue,
		"walkable": false,
		"resources": {}
	}

static func create_desert() -> Dictionary:
	return {
		"biome_name": "Desert",
		"color": Color.yellow,
		"walkable": true,
		"resources": {}
	}
