class_name Character
extends Node

var health: int = 10
var equipment: Array = []
var position: Vector2
var team_color: Color

func initialize(pos: Vector2, color: Color) -> void:
	position = pos
	team_color = color
