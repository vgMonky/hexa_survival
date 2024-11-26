class_name HexLocation
extends Node2D

signal hex_hovered(hex_data, grid_pos)
signal hex_unhovered

const HEX_SIZE = 32
const WIDTH_MULTIPLIER = 0.866

var hex_data: Dictionary
var grid_position: Vector2
var is_hovered: bool = false

func initialize(data: Dictionary, pos: Vector2) -> void:
	hex_data = data
	grid_position = pos
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
	
	# Draw border (thicker when hovered)
	var border_color = Color.yellow if is_hovered else Color.black
	var border_width = 2.0 if is_hovered else 1.0
	draw_polyline(points + [points[0]], border_color, border_width)
	
	# Draw character if present
	if hex_data.has("occupied") and hex_data["occupied"] != null:
		var character = hex_data["occupied"]
		var box_size = Vector2(float(HEX_SIZE)/2.0, float(HEX_SIZE)/2.0)
		draw_rect(Rect2(-box_size/2.0, box_size), character.team_color)

func _on_mouse_entered() -> void:
	is_hovered = true
	update()
	emit_signal("hex_hovered", hex_data, grid_position)

func _on_mouse_exited() -> void:
	is_hovered = false
	update()
	emit_signal("hex_unhovered")

func _ready() -> void:
	var area = Area2D.new()
	add_child(area)
	
	var collision = CollisionPolygon2D.new()
	var points = []
	for i in range(6):
		var angle = i * PI / 3.0
		var x = cos(angle) * HEX_SIZE
		var y = sin(angle) * HEX_SIZE
		points.append(Vector2(x, y))
	collision.polygon = points
	area.add_child(collision)
	
	area.connect("mouse_entered", self, "_on_mouse_entered")
	area.connect("mouse_exited", self, "_on_mouse_exited")
