# game/entities/character.gd
class_name Character
extends Node

var health: int = 10
var equipment: Array = []
var position: Vector2
var team_color: Color
var team_name: String  # Store team name instead of Team reference

func initialize(pos: Vector2, t_name: String, t_color: Color) -> void:
	position = pos
	team_name = t_name
	team_color = t_color
