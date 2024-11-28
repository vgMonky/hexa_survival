# main.gd
extends Node2D

func _ready() -> void:
	var state_manager = StateManager.new()
	add_child(state_manager)
	state_manager.initialize(7, 5)
	
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "Andre Team",
		"team_color": Color.red
	})
	
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "Vic Team",
		"team_color": Color.blue
	})
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "teet team",
		"team_color": Color.purple
	})

	var info_ui = InfoUI.new()
	add_child(info_ui)
	info_ui.update_state_info(state_manager.current_state, null)
	
	var turn_ui = TurnUI.new()
	add_child(turn_ui)
	turn_ui.initialize(state_manager)
	
	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(state_manager, info_ui)
	
	var teams_ui = TeamsUI.new()
	add_child(teams_ui)
	teams_ui.initialize(state_manager)
	
	# Connect state updates
	state_manager.connect("state_updated", turn_ui, "_on_state_updated")
	state_manager.connect("state_updated", teams_ui, "_on_state_updated")
