extends Node2D

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
	
	print("\nCreating pink team character...")
	# Create pink team character
	var character = Character.new()
	add_child(character)
	character.initialize(Vector2.ZERO, Color.pink)
	state_manager.place_entity(character, Vector2.ZERO)
	
	# Create info UI
	print("\nCreating UI...")
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
	
	print("Game initialization complete!\n")
