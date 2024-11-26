# view/map/hex_location.gd
class_name HexLocation
extends Area2D

const HEX_SIZE = 32

var hex_pos: Vector2
var is_hovered: bool = false
var biome_data: Dictionary

func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	# Create the collision shape for the Area2D
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = HEX_SIZE / 1.5
	add_child(collision_shape)

func initialize(pos: Vector2, hex_data: Dictionary = {}) -> void:
	hex_pos = pos
	if hex_data.has("biome_data"):
		biome_data = hex_data.biome_data
	update()

func _draw() -> void:
	var points = _get_hex_points()
	# Draw the hex shape with biome color
	var color = biome_data.get("color", Color.gray)
	draw_colored_polygon(points, color)
	
	# Draw the hex border
	if is_hovered:
		draw_polyline(points + [points[0]], Color.yellow, 3.0)
	else:
		draw_polyline(points + [points[0]], Color.black, 1.0)
	
	# Draw coordinates
	var coords_text = str(hex_pos)
	var font = Control.new().get_font("font")
	var coords_size = font.get_string_size(coords_text)
	var coords_pos = -coords_size / 2
	draw_string(font, coords_pos, coords_text, Color.black)

func _get_hex_points() -> Array:
	var points = []
	for i in range(6):
		var angle = i * PI / 3.0
		var x = cos(angle) * HEX_SIZE
		var y = sin(angle) * HEX_SIZE
		points.append(Vector2(x, y))
	return points

func _on_mouse_entered() -> void:
	is_hovered = true
	update()

func _on_mouse_exited() -> void:
	is_hovered = false
	update()
