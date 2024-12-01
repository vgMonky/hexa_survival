class_name MapViewContainer extends Node2D

var map_view: MapView
var zoom_level = 1.0
var zoom_min = 0.5
var zoom_max = 2.0
var zoom_step = 0.1

func _init(state_manager: StateManager) -> void:
	map_view = MapView.new(state_manager)
	add_child(map_view)

func _ready() -> void:
	# Center the map view within the container when the node is ready
	center_map_view()

func _draw() -> void:
	# Draw a cross at the center of the container
	var center = get_viewport_rect().size / 2
	var size = 10
	draw_line(center - Vector2(size, 0), center + Vector2(size, 0), Color.red, 2)
	draw_line(center - Vector2(0, size), center + Vector2(0, size), Color.red, 2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom_level = clamp(zoom_level + zoom_step, zoom_min, zoom_max)
			update_zoom()
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_level = clamp(zoom_level - zoom_step, zoom_min, zoom_max)
			update_zoom()

func update_zoom() -> void:
	map_view.scale = Vector2(zoom_level, zoom_level)
	center_map_view()

func center_map_view() -> void:
	var map_size = map_view.get_map_size()
	var container_size = get_viewport_rect().size
	var map_center = map_size * map_view.scale / 2
	var container_center = container_size / 2
	map_view.position = container_center - map_center
	update()  # Trigger a redraw to update the center visualization
