class_name GameMap
extends Node

static func create_hex_grid(grid_width: int, grid_height: int) -> Dictionary:
	# Initialize random number generator with current time
	randomize()
	
	var grid_data = {}
	
	for q in range(grid_width):
		for r in range(grid_height):
			var hex_pos = Vector2(q, r)
			grid_data[hex_pos] = {
				"biome": _random_biome(),
				"occupied": null  # Will store character reference
			}
			
	return grid_data

static func _random_biome() -> Dictionary:
	# Simple random distribution for now
	var chance = randf()
	if chance < 0.4:
		return BiomeData.create_woods()
	elif chance < 0.7:
		return BiomeData.create_desert()
	elif chance < 0.9:
		return BiomeData.create_cave()
	else:
		return BiomeData.create_water()

signal map_updated

var map_width: int
var map_height: int
var hex_data: Dictionary = {}

func initialize(new_width: int, new_height: int) -> void:
	map_width = new_width
	map_height = new_height
	hex_data = create_hex_grid(map_width, map_height)
	emit_signal("map_updated")

func get_hex_data(pos: Vector2) -> Dictionary:
	return hex_data.get(pos, {})

func is_walkable(pos: Vector2) -> bool:
	var data = get_hex_data(pos)
	if data.has("biome"):
		return data["biome"]["walkable"]
	return false

func get_hex_resources(pos: Vector2) -> Array:
	var data = get_hex_data(pos)
	var resources = []
	if data.has("biome"):
		for resource in data["biome"]["resources"]:
			if randf() < data["biome"]["resources"][resource]:
				resources.append(resource)
	return resources
