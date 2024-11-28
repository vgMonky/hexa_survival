# view/ui/teams_ui.gd
class_name TeamsUI
extends UIBox

var teams_container: VBoxContainer
var state_manager: StateManager

func _init(title: String = "Teams Info", pos_preset: int = Control.PRESET_CENTER_RIGHT).(title, pos_preset) -> void:
	set_margins(-200, 200, -10)
	teams_container = VBoxContainer.new()
	content.add_child(teams_container)

func initialize(manager: StateManager) -> void:
	state_manager = manager
	update_teams_info(state_manager.current_state)

func _on_state_updated() -> void:
	update_teams_info(state_manager.current_state)

func update_teams_info(state: GameState) -> void:
	# Clear previous info
	for child in teams_container.get_children():
		child.queue_free()
	
	# Add each team's info
	for team_name in state.teams.team_data:
		var team_data = state.teams.team_data[team_name]
		var inventory = team_data.get("inventory", {})
		
		# Team header (name and color)
		var team_header = Label.new()
		team_header.text = team_name
		team_header.modulate = team_data.color
		teams_container.add_child(team_header)
		
		# Team inventory
		if inventory.empty():
			var no_resources = Label.new()
			no_resources.text = "  No resources"
			teams_container.add_child(no_resources)
		else:
			for resource in inventory:
				var resource_label = Label.new()
				resource_label.text = "  %s: %d" % [resource, inventory[resource]]
				teams_container.add_child(resource_label)
		
		# Team members
		var members = state.teams.members[team_name]
		var members_label = Label.new()
		members_label.text = "  Members: %s" % str(members)
		teams_container.add_child(members_label)
		
		# Add separator between teams
		if team_name != state.teams.team_data.keys().back():
			teams_container.add_child(HSeparator.new())
