extends Node
class_name Character

var suren

func _init(sname: String = ""):
	suren = sname
	name = "Character" # Set the name to identify the node
	print("Character ", suren," created")
