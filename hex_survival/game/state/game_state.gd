# game/state/game_state.gd
class_name GameState
extends Reference

var map_data: Dictionary = {
	"width": 0,
	"height": 0,
	"hexes": {}  # hex_pos -> {biome, resources, entity}
}

var teams: Dictionary = {
	"team_data": {},  # team_name -> {color}
	"members": {}     # team_name -> [character_ids]
}

var entities: Dictionary = {
	"characters": {},  # id -> {health, team, position, equipment}
}

var turn_data: Dictionary = {
	"current_round": 0,
	"current_turn_index": 0,
	"turn_order": [],    # List of character IDs in turn order
	"actions_left": 0    # Actions remaining for current character
}

func _init(width: int, height: int) -> void:
	map_data.width = width
	map_data.height = height
