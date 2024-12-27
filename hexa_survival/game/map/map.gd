# Map.gd
extends Node
class_name Map

var height = 0
var width = 0

func _init(h: int, w: int):
	height = h
	width = w
	name = "Map"  # Set the name to identify the node
	print("Map created with dimensions:", h, "x", w)
