# main.gd
extends Node2D

func _init() -> void:
	print("TIMING: Main _init")

func _notification(what):
	match what:
		NOTIFICATION_INSTANCED:
			print("TIMING: Main scene instanced")
		NOTIFICATION_PARENTED:
			print("TIMING: Main scene parented")
		NOTIFICATION_PATH_CHANGED:
			print("TIMING: Main scene path changed")
		NOTIFICATION_READY:
			print("TIMING: Main scene notification ready")
		NOTIFICATION_ENTER_TREE:
			print("TIMING: Main scene enter tree")

func _enter_tree() -> void:
	print("TIMING: Main _enter_tree")
	
func _ready() -> void:
	print("TIMING: Main _ready starting")
	var state_manager = StateManager.new()
	print("TIMING: StateManager created")
	add_child(state_manager)
	print("TIMING: StateManager added to tree")
	state_manager.initialize(7, 5)
	print("TIMING: State initialized")
	
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "Andre Team",
		"team_color": Color.red
	})
	print("TIMING: First team added")
	
	state_manager.apply_state_change({
		"type": "add_team",
		"team_name": "Vic Team",
		"team_color": Color.blue
	})
	print("TIMING: Second team added")

	var info_ui = InfoUI.new()
	print("TIMING: InfoUI created")
	add_child(info_ui)
	info_ui.update_state_info(state_manager.current_state, null)
	
	var turn_ui = TurnUI.new()
	print("TIMING: TurnUI created")
	add_child(turn_ui)
	turn_ui.initialize(state_manager)
	
	var map_view = MapView.new()
	print("TIMING: MapView created")
	add_child(map_view)
	map_view.initialize(state_manager, info_ui)
	print("TIMING: MapView initialized")
	
	state_manager.connect("state_updated", turn_ui, "_on_state_updated")
	print("TIMING: _ready completed")
