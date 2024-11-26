class_name HexLocation
extends Node2D

const HEX_SIZE = 32
const WIDTH_MULTIPLIER = 0.866

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
	
	# Draw biome
	var color = Color.white
	if hex_data.has("biome"):
		color = hex_data["biome"]["color"]
	draw_colored_polygon(points, color)
	draw_polyline(points + [points[0]], Color.black, 1.0)
	
	# Draw character if present
	if hex_data.has("occupied") and hex_data["occupied"] != null:
		var character = hex_data["occupied"]
		var box_size = Vector2(float(HEX_SIZE)/2.0, float(HEX_SIZE)/2.0)
		draw_rect(Rect2(-box_size/2.0, box_size), character.team_color)
