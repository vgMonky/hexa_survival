extends Node2D

var red_team: Array = []
var pink_team: Array = []

func _ready() -> void:
	print("\nStarting game initialization...")
	
	# Create state manager
	var state_manager = StateManager.new()
	add_child(state_manager)
	state_manager.initialize(5, 5)
	
	print("\nCreating red team characters...")
	# Create red team characters
	for i in range(2):
		var character = Character.new()
		add_child(character)
		character.initialize(Vector2.ZERO, Color.red)
		print("Creating red character ", i + 1)
		state_manager.place_entity(character, Vector2.ZERO)
		red_team.append(character)
	
	print("\nCreating pink team character...")
	# Create pink team character
	var character = Character.new()
	add_child(character)
	character.initialize(Vector2.ZERO, Color.pink)
	state_manager.place_entity(character, Vector2.ZERO)
	pink_team.append(character)
	
	# Create turn system
	print("\nInitializing turn system...")
	var turn_system = TurnSystem.new(state_manager)
	add_child(turn_system)
	turn_system.initialize_characters(red_team, pink_team)
	
	# Create turn UI (pass turn_system reference)
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
	
	print("\nCreating map view...")
	# Create map view
	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(state_manager)
	map_view.connect("hex_hovered", info_ui, "update_hex_info")
	map_view.connect("hex_unhovered", info_ui, "clear_hex_info")
	
	# Start the game
	print("\nStarting turn system...")
	turn_system.start_game()
	
	print("Game initialization complete!\n")



	# Setup a timer for automatic turn progression (for testing)
	var turn_timer = Timer.new()
	add_child(turn_timer)
	turn_timer.wait_time = 2.0  # 2 seconds per turn
	turn_timer.connect("timeout", turn_system, "end_current_turn")
	turn_timer.start()
	print("Automatic turn progression started (2 seconds per turn)")
