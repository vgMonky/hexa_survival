# hex_survival/view/ui/info_ui.gd
class_name InfoUI
extends UIBox

var map_info: Label
var team_info: VBoxContainer
var hex_info: VBoxContainer

func _init(title: String = "", pos_preset: int = Control.PRESET_TOP_RIGHT).(title, pos_preset) -> void:
	set_margins(-200, 10, -10)
	map_info = Label.new()
	team_info = VBoxContainer.new()
	hex_info = VBoxContainer.new()
	content.add_child(map_info)
	content.add_child(HSeparator.new())
	content.add_child(team_info)
	content.add_child(HSeparator.new())
	content.add_child(hex_info)

func update_state_info(state: GameState, hovered_hex) -> void:
	map_info.text = "Map Size: %d x %d" % [state.map_data.width, state.map_data.height]
	map_info.text += "\nHexes: %d" % len(state.map_data.hexes)

	# Clear the previous team info
	for child in team_info.get_children():
		child.queue_free()

	# Display the list of teams and their colors
	var team_label = Label.new()
	team_label.text = "Teams: %d" % len(state.teams.team_data)
	team_info.add_child(team_label)
	for team_name in state.teams.team_data:
		var team_data = state.teams.team_data[team_name]
		team_label = Label.new()
		team_label.text = team_name
		team_label.modulate = team_data.color
		team_info.add_child(team_label)

	# Clear the previous hex info
	for child in hex_info.get_children():
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
		
		# Display entity if any
		hex_label = Label.new()
		hex_label.text = "Entity: %s" % str(hex_data.get("entity", "None"))
		hex_info.add_child(hex_label)
	else:
		hex_label = Label.new()
		hex_label.text = "No hex data available"
		hex_info.add_child(hex_label)
