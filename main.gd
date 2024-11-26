extends Node2D

func _ready() -> void:
	var game_map = GameMap.new()
	add_child(game_map)
	game_map.initialize(5, 5)  # 5x5 grid
	
	# Create and place character
	var character = Character.new()
	add_child(character)
	game_map.place_character(character)
	
	var map_view = MapView.new()
	add_child(map_view)
	map_view.initialize(game_map)
