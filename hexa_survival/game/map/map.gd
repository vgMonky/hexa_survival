# Map.gd
extends Node
class_name Map

var h = 0
var w = 0

func _init(height: int, width: int):
	h = height
	w = width
	name = "Map"  # Set the name to identify the node
	print("Map created with dimensions:", h, "x", w)
