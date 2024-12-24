# game/view/map/character_view.gd
class_name CharacterView
extends Node2D

const SIZE = 16  # Size of character square in pixels
var position_in_grid: Vector2
var character_id: String
var character_color: Color

func _init(char_id: String, grid_pos: Vector2, color: Color) -> void:
	position_in_grid = grid_pos
	character_id = char_id
	character_color = color
	position = grid_to_screen_position(grid_pos)

func _draw() -> void:
	# Draw a square to represent the character
	var rect = Rect2(Vector2.ZERO, Vector2(SIZE, SIZE))
	draw_rect(rect, character_color)

func grid_to_screen_position(grid_pos: Vector2) -> Vector2:
	var x = grid_pos.x * HexView.HEX_SIZE * 1.5
	var y = grid_pos.y * HexView.HEX_SIZE * sqrt(3)
	if int(grid_pos.x) % 2:
		y += HexView.HEX_SIZE * sqrt(3) / 2
	return Vector2(x, y)
