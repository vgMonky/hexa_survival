class_name InfoUI
extends Control

# UI Elements
var panel: PanelContainer
var info_container: VBoxContainer
var map_info: Label
var hex_info: Label
var character_info: Label

# Dragging variables
var dragging: bool = false
var drag_start_pos: Vector2

func _ready() -> void:
	# Create panel
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	panel.margin_right = -10
	panel.margin_top = 10
	panel.margin_left = -200
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Create container for all info
	info_container = VBoxContainer.new()
	info_container.margin_left = 10
	info_container.margin_right = 10
	info_container.margin_top = 5
	info_container.margin_bottom = 5
	
	# Create labels
	map_info = Label.new()
	hex_info = Label.new()
	character_info = Label.new()
	
	# Add to container
	info_container.add_child(map_info)
	info_container.add_child(hex_info)
	info_container.add_child(character_info)
	
	# Build hierarchy
	panel.add_child(info_container)
	add_child(panel)
	
	# Initialize empty
	clear_hex_info()

func update_map_info(game_map: GameMap) -> void:
	map_info.text = "Map Info:\n"
	map_info.text += "Size: %d x %d\n" % [game_map.map_width, game_map.map_height]
	map_info.text += "Total Hexes: %d" % len(game_map.hex_data)

func update_hex_info(hex_data: Dictionary, pos: Vector2) -> void:
	if hex_data.empty():
		clear_hex_info()
		return
		
	hex_info.text = "\nHex Info:\n"
	hex_info.text += "Position: (%d, %d)\n" % [pos.x, pos.y]
	if hex_data.has("biome"):
		hex_info.text += "Biome: %s\n" % hex_data["biome"]["biome_name"]
		hex_info.text += "Walkable: %s\n" % ("Yes" if hex_data["biome"]["walkable"] else "No")
		
		# Show resources
		var resources = hex_data["biome"]["resources"]
		if not resources.empty():
			hex_info.text += "Possible Resources:\n"
			for resource in resources:
				var chance = resources[resource] * 100
				hex_info.text += "  %s (%d%%)\n" % [resource, chance]
	
	if hex_data.has("occupied") and hex_data["occupied"] != null:
		var character = hex_data["occupied"]
		character_info.text = "\nCharacter Info:\n"
		character_info.text += "Health: %d\n" % character.health
		character_info.text += "Equipment: %s\n" % (str(character.equipment) if not character.equipment.empty() else "Empty")
	else:
		character_info.text = ""

func clear_hex_info() -> void:
	hex_info.text = "\nHover over a hex to see info"
	character_info.text = ""

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_start_pos = event.position
			else:
				dragging = false
	
	elif event is InputEventMouseMotion and dragging:
		panel.margin_left += event.relative.x
		panel.margin_right += event.relative.x
		panel.margin_top += event.relative.y
		panel.margin_bottom += event.relative.y
