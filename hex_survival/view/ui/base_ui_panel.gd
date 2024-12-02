# view/ui/base_ui_panel.gd
class_name BaseUIPanel
extends Control

var dragging := false
var drag_start_position := Vector2()
var title := "Panel"
var min_size := Vector2(200, 100)

# Reference to content container for child classes
var content_container: MarginContainer

func _init(panel_title: String = "Panel") -> void:
	title = panel_title
	# Set up the basic structure in _init instead of _ready
	_setup_panel()

func _setup_panel() -> void:
	# Set minimum size
	rect_min_size = min_size
	
	# Create panel container
	var panel = PanelContainer.new()
	add_child(panel)
	
	# Create main VBox
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	# Create title bar
	var title_bar = HBoxContainer.new()
	title_bar.add_constant_override("separation", 8)
	vbox.add_child(title_bar)
	
	# Add title label
	var label = Label.new()
	label.text = title
	label.size_flags_horizontal = SIZE_EXPAND_FILL
	title_bar.add_child(label)

	# Add separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Add content container
	content_container = MarginContainer.new()
	content_container.add_constant_override("margin_left", 8)
	content_container.add_constant_override("margin_right", 8)
	content_container.add_constant_override("margin_top", 8)
	content_container.add_constant_override("margin_bottom", 8)
	vbox.add_child(content_container)
	
	# Enable drag handling
	title_bar.connect("gui_input", self, "_on_title_bar_input")

func _on_title_bar_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			dragging = event.pressed
			drag_start_position = get_local_mouse_position()
	elif event is InputEventMouseMotion and dragging:
		rect_position += get_local_mouse_position() - drag_start_position

