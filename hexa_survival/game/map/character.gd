# Character.gd
extends Node
class_name Character

var surename

func _init(sn: String = ""):
	surename = sn
	name = "Character"  # Set the name to identify the node
	print("Character ", surename, " created")
