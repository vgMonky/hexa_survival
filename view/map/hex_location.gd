class_name HexLocation
extends Node2D

const HEX_SIZE = 32

var hex_data: Dictionary

func initialize(data: Dictionary) -> void:
	hex_data = data
	update()

func _draw() -> void:
	var points = []
	for i in range(6):
		var angle = i * PI / 3.0
		var x = cos(angle) * HEX_SIZE
		var y = sin(angle) * HEX_SIZE
		points.append(Vector2(x, y))
	
	draw_colored_polygon(points, Color.gray)
	draw_polyline(points + [points[0]], Color.black, 1.0)
