class_name Team
extends Node

var team_name: String
var team_color: Color
var characters: Array = []

func _init(name: String, color: Color) -> void:
	team_name = name
	team_color = color
	print("Team created: ", team_name, " with color: ", team_color)

func add_character(character: Character) -> void:
	characters.append(character)
	character.team_color = team_color
	print("Character added to team ", team_name)

func get_characters() -> Array:
	return characters
