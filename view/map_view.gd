class_name MapView
extends Node2D

# Inner class for hex visualization
class HexLocation extends Node2D:
	const HEX_SIZE = 32
	const WIDTH_MULTIPLIER = 0.866
	
	var hex_data: Dictionary

	func initialize(data: Dictionary) -> void:
		hex_data = data
		update()  # Trigger redraw

	func _draw() -> void:
		var points = []
		for i in range(6):
			var angle = i * PI / 3.0
			var x = cos(angle) * HEX_SIZE
			var y = sin(angle) * HEX_SIZE
			points.append(Vector2(x, y))
		
		# Use biome color or white as fallback
		var color = Color.white
		if hex_data.has("biome"):
			color = hex_data["biome"]["color"]
		
		draw_colored_polygon(points, color)
		draw_polyline(points + [points[0]], Color.black, 1.0)
		
# Map View properties
var game_map: GameMap
var hex_locations = {}

# Camera control variables
var camera: Camera2D
var zoom_level: float = 1.0
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 2.0
const ZOOM_SPEED: float = 0.1

func _ready() -> void:
	# Create and setup camera
	camera = Camera2D.new()
	camera.make_current()
	add_child(camera)

func initialize(map: GameMap) -> void:
	game_map = map
	assert(game_map.connect("map_updated", self, "_on_map_updated") == OK)
	_create_visual_map()
	_center_camera()

func _create_visual_map() -> void:
	for hex in hex_locations.values():
		hex.queue_free()
	hex_locations.clear()
	
	for pos in game_map.hex_data.keys():
		var hex = HexLocation.new()
		add_child(hex)
		
		var pixel_x = HexLocation.HEX_SIZE * (3.0/2.0 * pos.x)
		var pixel_y = HexLocation.HEX_SIZE * (sqrt(3)/2.0 * pos.x + sqrt(3) * pos.y)
		
		hex.position = Vector2(pixel_x, pixel_y)
		hex.initialize(game_map.hex_data[pos])
		hex_locations[pos] = hex

func _center_camera() -> void:
	if hex_locations.empty():
		return
		
	# Calculate map bounds
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	
	for hex in hex_locations.values():
		min_x = min(min_x, hex.position.x)
		max_x = max(max_x, hex.position.x)
		min_y = min(min_y, hex.position.y)
		max_y = max(max_y, hex.position.y)
	
	# Center camera on map center
	camera.position = Vector2(
		(min_x + max_x) / 2,
		(min_y + max_y) / 2
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom_level = clamp(zoom_level - ZOOM_SPEED, MIN_ZOOM, MAX_ZOOM)
			camera.zoom = Vector2.ONE * zoom_level
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_level = clamp(zoom_level + ZOOM_SPEED, MIN_ZOOM, MAX_ZOOM)
			camera.zoom = Vector2.ONE * zoom_level

func _on_map_updated() -> void:
	_create_visual_map()
	_center_camera()
