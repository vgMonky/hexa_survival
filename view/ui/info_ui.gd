# view/ui/info_ui.gd
class_name InfoUI
extends UIBox

var map_info: Label
var hex_info: Label
var team_info: Label

func _init().("Game Info", Control.PRESET_TOP_RIGHT) -> void:
	set_margins(-200, 10, -10)
	
	map_info = Label.new()
	hex_info = Label.new()
	team_info = Label.new()
	
	content.add_child(map_info)
	content.add_child(hex_info)
	content.add_child(team_info)
	
	map_info.text = "Hover over map for info"

func update_state_info(state: GameState) -> void:
	map_info.text = "Map Info:\n"
	map_info.text += "Size: %d x %d\n" % [state.map_data.width, state.map_data.height]
	map_info.text += "Teams: %d" % len(state.teams.team_data)
