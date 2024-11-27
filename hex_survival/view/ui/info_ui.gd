# view/ui/info_ui.gd
class_name InfoUI
extends UIBox

var map_info: Label
var team_info: VBoxContainer

func _init(title: String = "", pos_preset: int = Control.PRESET_TOP_RIGHT).(title, pos_preset) -> void:
	set_margins(-200, 10, -10)
	map_info = Label.new()
	team_info = VBoxContainer.new()
	content.add_child(map_info)
	content.add_child(HSeparator.new())
	content.add_child(team_info)

func update_state_info(state: GameState) -> void:
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
