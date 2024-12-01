# game/data/map.gd
class_name Map
extends Reference

var width: int
var height: int
var hexes: Dictionary  # Vector2 -> Dictionary (not HexTile directly)

func _init(w: int, h: int) -> void:
	width = w
	height = h
	hexes = {}

func initialize() -> void:
	print("Initializing map grid ", width, "x", height)
	for x in range(width):
		for y in range(height):
			var pos = Vector2(x, y)
			var hex = HexTile.new(pos)
			hexes[pos] = hex.to_dict()
	print("Map grid initialized with ", hexes.size(), " hexes")

func to_dict() -> Dictionary:
	return {
		"width": width,
		"height": height,
		"hexes": hexes
	}
