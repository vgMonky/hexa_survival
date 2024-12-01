class_name HexView
extends Node2D

const HEX_SIZE = 32  # Size of hex in pixels
var position_in_grid: Vector2
var biome_data: Dictionary
var show_coordinate = true

func _init(grid_pos: Vector2, hex_data: Dictionary) -> void:
	position_in_grid = grid_pos
	biome_data = hex_data
	# Convert grid position to screen position
	position = grid_to_screen_position(grid_pos)

func _draw() -> void:
	var points = calculate_hex_points()
	var color = biome_data.biome_data.color
	draw_colored_polygon(points, color)
	# Optional: draw outline
	for i in range(points.size()):
		var next_i = (i + 1) % points.size()
		draw_line(points[i], points[next_i], Color.black, 1.0)
	# Show hex coordinate
	if show_coordinate == true:
		var tag = Label.new()
		tag.text = String(position_in_grid) 
		# Set the alignment to center
		tag.align = Label.ALIGN_CENTER
		tag.valign = Label.VALIGN_CENTER
		# Set the anchor to center
		tag.set_anchors_and_margins_preset(Control.PRESET_CENTER)
		add_child(tag)
		
func calculate_hex_points() -> Array:
	var points = []
	for i in range(6):
		var angle = i * PI / 3.0  # 60 degrees
		var x = HEX_SIZE * cos(angle)
		var y = HEX_SIZE * sin(angle)
		points.append(Vector2(x, y))
	return points

func grid_to_screen_position(grid_pos: Vector2) -> Vector2:
	var x = grid_pos.x * HEX_SIZE * 1.5
	var y = grid_pos.y * HEX_SIZE * sqrt(3)
	if int(grid_pos.x) % 2:
		y += HEX_SIZE * sqrt(3) / 2
	return Vector2(x, y)
