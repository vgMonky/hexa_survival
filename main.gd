extends Node2D

func _ready() -> void:
	var game_map = GameMap.new()
	add_child(game_map)
	game_map.initialize(5, 5)  # 5x5 grid
	
	# Create red team characters
	for _i in range(2):  # Added underscore to show it's intentionally unused
		var character = Character.new()
		add_child(character)
		character.initialize(Vector2.ZERO, Color.red)
		game_map.place_character(character)
	
	# Create pink team character
	var character = Character.new()
	add_child(character)
	character.initialize(Vector2.ZERO, Color.pink)
	game_map.place_character(character)
	
	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(game_map)
