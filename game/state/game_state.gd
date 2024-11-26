class_name GameState
extends Reference

var width: int
var height: int
var hex_grid: Dictionary = {}  # Stores biome data
var entity_positions: Dictionary = {}  # position -> character

func _init(w: int, h: int) -> void:
	width = w
	height = h

func is_valid_position(pos: Vector2) -> bool:
	return hex_grid.has(pos)

func get_hex_data(pos: Vector2) -> Dictionary:
	return hex_grid.get(pos, {})

func get_entity_at(pos: Vector2) -> Node:
	return entity_positions.get(pos)
