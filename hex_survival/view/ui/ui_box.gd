# view/ui/ui_box.gd
class_name UIBox
extends Control

var panel: PanelContainer
var content: VBoxContainer
var title_label: Label

var dragging: bool = false
var drag_start_pos: Vector2

func _init(title: String = "", pos_preset: int = Control.PRESET_TOP_RIGHT) -> void:
   panel = PanelContainer.new()
   panel.set_anchors_preset(pos_preset)
   panel.mouse_filter = Control.MOUSE_FILTER_PASS
   
   content = VBoxContainer.new()
   content.margin_left = 10
   content.margin_right = 10
   content.margin_top = 5
   content.margin_bottom = 5
   
   if title != "":
	   title_label = Label.new()
	   title_label.text = title
	   title_label.align = Label.ALIGN_CENTER
	   content.add_child(title_label)
	   content.add_child(HSeparator.new())
   
   panel.add_child(content)
   add_child(panel)

func set_margins(left: int, top: int, right: int = 200) -> void:
   panel.margin_left = left
   panel.margin_top = top
   panel.margin_right = right

func _gui_input(event: InputEvent) -> void:
   if event is InputEventMouseButton:
	   if event.button_index == BUTTON_LEFT:
		   dragging = event.pressed
		   drag_start_pos = event.position
   elif event is InputEventMouseMotion and dragging:
	   panel.margin_left += event.relative.x
	   panel.margin_right += event.relative.x
	   panel.margin_top += event.relative.y
	   panel.margin_bottom += event.relative.y
