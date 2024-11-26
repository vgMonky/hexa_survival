class_name Character
extends Node

var health: int = 10
var inventory: Array = []
var position: Vector2  # Store grid coordinates

func initialize(pos: Vector2) -> void:
	position = pos
