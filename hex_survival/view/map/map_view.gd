class_name MapView
extends Node2D

var state_manager: StateManager
var hex_locations = {}
var camera: Camera2D
var zoom_level: float = 1.0
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 2.0
const ZOOM_SPEED: float = 0.1
var info_ui: InfoUI

func _ready() -> void:
	camera = Camera2D.new()
	camera.make_current()
	add_child(camera)

func initialize(manager: StateManager, info_ui_instance: InfoUI) -> void:
	state_manager = manager
	info_ui = info_ui_instance
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
			hex.connect("mouse_entered", self, "_on_hex_mouse_entered", [hex])
			hex.connect("mouse_exited", self, "_on_hex_mouse_exited", [hex])
			add_child(hex)
			var pos = Vector2(q, r)
			hex.position = _get_hex_position(pos)
			hex.initialize(pos)
			hex_locations[pos] = hex

func _get_hex_position(pos: Vector2) -> Vector2:
	return Vector2(
		HexLocation.HEX_SIZE * (3.0/2.0 * pos.x),
		HexLocation.HEX_SIZE * (sqrt(3)/2.0 * pos.x + sqrt(3) * pos.y)
	)

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

func _on_hex_mouse_entered(hex: HexLocation) -> void:
	_update_info_ui(hex.hex_pos)

func _on_hex_mouse_exited(_hex: HexLocation) -> void:
	_update_info_ui(null)

func _update_info_ui(hovered_hex) -> void:
	if info_ui:
		info_ui.update_state_info(state_manager.current_state, hovered_hex)

func _on_state_updated() -> void:
	_create_visual_map()
	_center_camera()
