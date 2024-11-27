class_name HexLocation
extends Node2D

const HEX_SIZE = 32

var hex_pos: Vector2

func initialize(pos: Vector2) -> void:
	hex_pos = pos
	update()

func _draw() -> void:
	var points = []
	for i in range(6):
		var angle = i * PI / 3.0
		var x = cos(angle) * HEX_SIZE
		var y = sin(angle) * HEX_SIZE
		points.append(Vector2(x, y))
	
	# Draw the hex shape
	draw_colored_polygon(points, Color.gray)
	draw_polyline(points + [points[0]], Color.black, 1.0)
	
	# Draw the hex coordinates as text in the center
	var text = str(hex_pos)
	var font = Control.new().get_font("font")
	var text_size = font.get_string_size(text)
	var text_pos = -text_size / 2
	draw_string(font, text_pos, text, Color.black)
