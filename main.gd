extends Node2D

func _ready() -> void:
	print("\nStarting game initialization...")
	
	# Create managers
	var state_manager = StateManager.new()
	var team_manager = TeamManager.new()
	add_child(state_manager)
	add_child(team_manager)
	state_manager.initialize(5, 5)
	
	# Create teams
	print("\nCreating teams...")
	team_manager.create_team("Red Team", Color.red)
	team_manager.create_team("Pink Team", Color.pink)
	team_manager.create_team("Fausto", Color.purple)
	
	print("\nCreating characters...")
	# Add characters to all teams
	for team in team_manager.get_all_teams():
		for _i in range(2):
			team_manager.add_character_to_team(team.team_name, state_manager)
	
	# Initialize turn system
	print("\nInitializing turn system...")
	var turn_system = TurnSystem.new(state_manager)
	add_child(turn_system)
	# Get characters from teams
	var teams = team_manager.get_all_teams()
	var character_order = []
	for team in teams:
		character_order.append_array(team.get_characters())
	turn_system.initialize_characters(character_order)
	
	# Create turn UI
	print("\nCreating turn UI...")
	var turn_ui = TurnUI.new(turn_system)
	add_child(turn_ui)
	turn_system.connect("turn_started", turn_ui, "_on_turn_started")
	turn_system.connect("turn_ended", turn_ui, "_on_turn_ended")
	turn_system.connect("round_ended", turn_ui, "_on_round_ended")
	
	# Create info UI
	print("\nCreating info UI...")
	var info_ui = InfoUI.new()
	add_child(info_ui)
	info_ui.update_map_info(state_manager.current_state)
	
	# Create map view
	print("\nCreating map view...")
	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(state_manager)
	map_view.connect("hex_hovered", info_ui, "update_hex_info")
	map_view.connect("hex_unhovered", info_ui, "clear_hex_info")
	
	# Setup turn timer
	var turn_timer = Timer.new()
	add_child(turn_timer)
	turn_timer.wait_time = 2.0
	turn_timer.connect("timeout", turn_system, "end_current_turn")
	turn_timer.start()
	
	# Start the game
	print("\nStarting turn system...")
	turn_system.start_game()
	
	print("Game initialization complete!\n")
