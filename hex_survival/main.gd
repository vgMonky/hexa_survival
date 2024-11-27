extends Node2D

func _ready() -> void:
	var state_manager = StateManager.new()
	add_child(state_manager)
	state_manager.initialize(7, 5)
	
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "Red Team",
		"team_color": Color.red
	})
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "Vic Team",
		"team_color": Color.blue
	})

	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(state_manager)
	
	var info_ui = InfoUI.new()
	add_child(info_ui)
	info_ui.update_state_info(state_manager.current_state)
