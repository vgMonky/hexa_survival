# view/map/character_view.gd
class_name CharacterView
extends Node2D

const CHARACTER_SIZE = 20

var character_data: Dictionary
var team_color: Color

func _init(char_data: Dictionary, color: Color) -> void:
	print("[CharView] Init with color: ", color)
	character_data = char_data
	team_color = color
	z_index = 1

func _ready() -> void:
	print("CharacterView ready, position: ", position)
	update()  # Force redraw

func _draw() -> void:
	print("Drawing character with color: ", team_color)
	# Draw character as a colored rectangle
	var rect_size = Vector2(CHARACTER_SIZE, CHARACTER_SIZE)
	var rect_pos = -rect_size / 2
	draw_rect(Rect2(rect_pos, rect_size), team_color)
	draw_rect(Rect2(rect_pos, rect_size), Color.black, false, 2.0)
