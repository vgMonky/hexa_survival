class_name MapView
extends Node2D

signal hex_hovered(hex_data, grid_pos)
signal hex_unhovered

var state_manager: StateManager
var hex_locations = {}
var current_hovered_hex: HexLocation = null

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

func initialize(manager: StateManager) -> void:
	state_manager = manager
	assert(state_manager.connect("state_updated", self, "_on_state_updated") == OK)
	_create_visual_map()
	_center_camera()

func _create_visual_map() -> void:
	for hex in hex_locations.values():
		hex.queue_free()
	hex_locations.clear()
	current_hovered_hex = null
	
	var state = state_manager.current_state
	for pos in state.hex_grid.keys():
		var hex = HexLocation.new()
		add_child(hex)
		
		var pixel_x = HexLocation.HEX_SIZE * (3.0/2.0 * pos.x)
		var pixel_y = HexLocation.HEX_SIZE * (sqrt(3)/2.0 * pos.x + sqrt(3) * pos.y)
		
		hex.position = Vector2(pixel_x, pixel_y)
		hex.initialize(state.hex_grid[pos], pos)
		hex.connect("hex_hovered", self, "_on_hex_hovered")
		hex.connect("hex_unhovered", self, "_on_hex_unhovered")
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

func _on_state_updated() -> void:
	_create_visual_map()
	_center_camera()

func _on_hex_hovered(hex_data: Dictionary, grid_pos: Vector2) -> void:
	if current_hovered_hex != null:
		current_hovered_hex.is_hovered = false
		current_hovered_hex.update()
	current_hovered_hex = hex_locations[grid_pos]
	emit_signal("hex_hovered", hex_data, grid_pos)

func _on_hex_unhovered() -> void:
	yield(get_tree(), "idle_frame")
	if current_hovered_hex and not current_hovered_hex.is_hovered:
		current_hovered_hex = null
		emit_signal("hex_unhovered")
