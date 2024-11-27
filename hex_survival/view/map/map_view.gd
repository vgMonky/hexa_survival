class_name MapView
extends Node2D

var state_manager: StateManager
var hex_locations = {}
var camera: Camera2D
var zoom_level: float = 1.0
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 2.0
const ZOOM_SPEED: float = 0.1

func _ready() -> void:
	camera = Camera2D.new()
	camera.make_current()
	add_child(camera)

func initialize(manager: StateManager) -> void:
	state_manager = manager
	assert(state_manager.connect("state_updated", self, "_on_state_updated") == OK)
	_create_visual_map()
	_center_camera()

func _create_visual_map() -> void:
	for hex in hex_locations.values():
		hex.queue_free()
	hex_locations.clear()
	
	for q in range(state_manager.current_state.map_data.width):
		for r in range(state_manager.current_state.map_data.height):
			var hex = HexLocation.new()
			add_child(hex)
			var pos = Vector2(q, r)
			hex.position = Vector2(
				HexLocation.HEX_SIZE * (3.0/2.0 * q),
				HexLocation.HEX_SIZE * (sqrt(3)/2.0 * q + sqrt(3) * r)
			)
			hex_locations[pos] = hex

func _center_camera() -> void:
	if hex_locations.empty():
		return
	
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	
	for hex in hex_locations.values():
		min_x = min(min_x, hex.position.x)
		max_x = max(max_x, hex.position.x)
		min_y = min(min_y, hex.position.y)
		max_y = max(max_y, hex.position.y)
	
	camera.position = Vector2((min_x + max_x) / 2, (min_y + max_y) / 2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom_level = clamp(zoom_level - ZOOM_SPEED, MIN_ZOOM, MAX_ZOOM)
			camera.zoom = Vector2.ONE * zoom_level
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_level = clamp(zoom_level + ZOOM_SPEED, MIN_ZOOM, MAX_ZOOM)
			camera.zoom = Vector2.ONE * zoom_level

func _on_state_updated() -> void:
	_create_visual_map()
	_center_camera()