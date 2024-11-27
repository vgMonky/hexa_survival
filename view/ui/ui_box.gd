class_name UIBox
extends Control

# UI Elements
var panel: PanelContainer
var content_container: VBoxContainer
var title_label: Label
var separator: HSeparator

# Dragging variables
var dragging: bool = false
var drag_start_pos: Vector2

func _init(title: String = "", position_preset: int = Control.PRESET_TOP_RIGHT) -> void:
	# Create panel
	panel = PanelContainer.new()
	panel.set_anchors_preset(position_preset)
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Create container for content
	content_container = VBoxContainer.new()
	content_container.margin_left = 10
	content_container.margin_right = 10
	content_container.margin_top = 5
	content_container.margin_bottom = 5
	
	# Create title if provided
	if title != "":
		title_label = Label.new()
		title_label.text = title
		title_label.align = Label.ALIGN_CENTER
		content_container.add_child(title_label)
		
		separator = HSeparator.new()
		content_container.add_child(separator)
	
	# Build hierarchy
	panel.add_child(content_container)
	add_child(panel)
	
	print("UIBox initialized with title: ", title)

func set_margins(left: int, top: int, right: int = 200) -> void:
	panel.margin_left = left
	panel.margin_top = top
	panel.margin_right = right

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_start_pos = event.position
				print("Started dragging UI box")
			else:
				dragging = false
				print("Stopped dragging UI box")
	
	elif event is InputEventMouseMotion and dragging:
		panel.margin_left += event.relative.x
		panel.margin_right += event.relative.x
		panel.margin_top += event.relative.y
		panel.margin_bottom += event.relative.y
