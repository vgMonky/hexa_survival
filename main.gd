extends Node2D

func _ready() -> void:
	var game_map = GameMap.new()
	add_child(game_map)
	game_map.initialize(5, 5)  # 5x5 grid
	
	# Create teams arrays
	var red_team = []
	var pink_team = []
	
	# Create red team characters
	for _i in range(2):
		var character = Character.new()
		add_child(character)
		character.initialize(Vector2.ZERO, Color.red)
		game_map.place_character(character)
		red_team.append(character)
	
	# Create pink team character
	var character = Character.new()
	add_child(character)
	character.initialize(Vector2.ZERO, Color.pink)
	game_map.place_character(character)
	pink_team.append(character)
	
	# Create info UI
	var info_ui = InfoUI.new()
	add_child(info_ui)
	info_ui.update_map_info(game_map)
	
	# Create map view
	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(game_map)
	map_view.connect("hex_hovered", info_ui, "update_hex_info")
	map_view.connect("hex_unhovered", info_ui, "clear_hex_info")
	
	# Start the game
	game_map.start_game(red_team, pink_team)
