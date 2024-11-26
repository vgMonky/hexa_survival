extends Node2D

func _ready() -> void:
	var game_map = GameMap.new()
	add_child(game_map)
	game_map.initialize(5, 5)  # 5x5 grid
	
	var map_view = preload("res://view/map.tscn").instance()
	add_child(map_view)
	map_view.initialize(game_map)
