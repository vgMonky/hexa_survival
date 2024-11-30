# hex_survival/view/ui/info_ui.gd
class_name InfoUI
extends UIBox

var map_info: Label
var hex_info: VBoxContainer
var character_info: VBoxContainer

const ITEM_ICONS = {
	"wooden_sword": preload("res://assets/items/sword.png"),
	"wooden_shield": preload("res://assets/items/shield.jpg")
}

func _init(title: String = "", pos_preset: int = Control.PRESET_TOP_RIGHT).(title, pos_preset) -> void:
	set_margins(-200, 10, -10)
	map_info = Label.new()
	hex_info = VBoxContainer.new()
	character_info = VBoxContainer.new()
	
	content.add_child(map_info)
	content.add_child(HSeparator.new())
	content.add_child(hex_info)
	content.add_child(HSeparator.new())
	content.add_child(character_info)

func update_state_info(state: GameState, hovered_hex) -> void:
	map_info.text = "Map Size: %d x %d" % [state.map_data.width, state.map_data.height]
	map_info.text += "\nHexes: %d" % len(state.map_data.hexes)

	# Clear the previous hex info
	for child in hex_info.get_children():
		child.queue_free()
	for child in character_info.get_children():
		child.queue_free()

	# Display the info for the hovered hex
	var hex_label = Label.new()
	hex_label.text = "Hovered Hex: %s" % str(hovered_hex)
	hex_info.add_child(hex_label)

	if hovered_hex in state.map_data.hexes:
		var hex_data = state.map_data.hexes[hovered_hex]
		
		# Display biome type
		hex_label = Label.new()
		hex_label.text = "Biome: %s" % str(hex_data.get("biome", "None"))
		hex_info.add_child(hex_label)
		
		# Display walkability
		hex_label = Label.new()
		var walkable = hex_data.get("biome_data", {}).get("walkable", false)
		hex_label.text = "Walkable: %s" % ("Yes" if walkable else "No")
		hex_info.add_child(hex_label)
		
		# Display resources and their chances
		var resources = hex_data.get("biome_data", {}).get("resources", {})
		if resources.empty():
			hex_label = Label.new()
			hex_label.text = "Resources: None"
			hex_info.add_child(hex_label)
		else:
			hex_label = Label.new()
			hex_label.text = "Resources:"
			hex_info.add_child(hex_label)
			
			for resource in resources:
				var chance = resources[resource] * 100
				hex_label = Label.new()
				hex_label.text = "  - %s: %.1f%%" % [resource, chance]
				hex_info.add_child(hex_label)
		
		# If there's a character on this hex, show their info
		var entity_id = hex_data.get("entity")
		if entity_id != null and state.entities.characters.has(entity_id):
			var char_data = state.entities.characters[entity_id]
			var team_data = state.teams.team_data[char_data.team]
			
			var char_header = Label.new()
			char_header.text = "\nCharacter Info:"
			character_info.add_child(char_header)
			
			var char_label = Label.new()
			char_label.text = "ID: %s" % entity_id
			char_label.modulate = team_data.color
			character_info.add_child(char_label)
			
			char_label = Label.new()
			char_label.text = "Team: %s" % char_data.team
			char_label.modulate = team_data.color
			character_info.add_child(char_label)
			
			char_label = Label.new()
			char_label.text = "Health: %d/%d" % [char_data.current_life, char_data.max_life]
			character_info.add_child(char_label)
			
			if not char_data.equipment.empty():
				var equip_header = Label.new()
				equip_header.text = "Equipment:"
				character_info.add_child(equip_header)
				
				for item in char_data.equipment:
					var h_box = HBoxContainer.new()
					h_box.add_constant_override("separation", 5)
					character_info.add_child(h_box)
					
					# Add icon if available
					if ITEM_ICONS.has(item.id):
						var icon = TextureRect.new()
						icon.texture = ITEM_ICONS[item.id]
						icon.rect_min_size = Vector2(16, 16)
						icon.expand = true
						icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
						h_box.add_child(icon)
					
					# Add item name
					var item_label = Label.new()
					item_label.text = item.name
					item_label.modulate = team_data.color
					h_box.add_child(item_label)
