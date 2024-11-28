# view/map/hex_location.gd
class_name HexLocation
extends Area2D

const HEX_SIZE = 32
const MOVE_INDICATOR_SIZE = 8
const MOVE_INDICATOR_COLOR = Color(1, 0, 1, 0.8)
const HOVER_COLOR = Color(1, 0, 1, 1)

var hex_pos: Vector2
var is_hovered: bool = false
var biome_data: Dictionary
var is_valid_move: bool = false

func _ready() -> void:
	# Connect the signals
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
	# Create the collision shape for the Area2D
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = HEX_SIZE / 1.5
	add_child(collision_shape)

func _draw() -> void:
	var points = _get_hex_points()
	# Draw the hex shape with biome color
	var color = biome_data.get("color", Color.gray)
	draw_colored_polygon(points, color)
	
	# Draw the hex border
	if is_hovered:
		draw_polyline(points + [points[0]], HOVER_COLOR, 3.0)
	else:
		draw_polyline(points + [points[0]], Color.black, 1.0)
	
	# Draw movement indicator
	if is_valid_move:
		# Draw center glow circle
		draw_circle(Vector2.ZERO, MOVE_INDICATOR_SIZE, MOVE_INDICATOR_COLOR)
		# Add outer glow with transparency
		var outer_color = MOVE_INDICATOR_COLOR
		outer_color.a = 0.3
		draw_circle(Vector2.ZERO, MOVE_INDICATOR_SIZE * 1.5, outer_color)

func _get_hex_points() -> Array:
	var points = []
	for i in range(6):
		var angle = i * PI / 3.0
		var x = cos(angle) * HEX_SIZE
		var y = sin(angle) * HEX_SIZE
		points.append(Vector2(x, y))
	return points

func initialize(pos: Vector2, hex_data: Dictionary = {}) -> void:
	hex_pos = pos
	if hex_data.has("biome_data"):
		biome_data = hex_data.biome_data
	update()

func set_valid_move(valid: bool) -> void:
	# Only print when setting to true to reduce output
	if valid:
		print("[Hex] Valid move at: ", hex_pos)
	is_valid_move = valid
	update()



func _on_mouse_entered() -> void:
	is_hovered = true
	update()

func _on_mouse_exited() -> void:
	is_hovered = false
	update()
