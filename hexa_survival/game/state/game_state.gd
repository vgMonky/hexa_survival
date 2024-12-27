extends Node

class_name GameState

# Custom copy method to duplicate the node and its children
func copy() -> GameState:
	var new_state = self.get_script().new() # Dynamically create a new instance of the same script
	# Duplicate all child nodes
	for child in get_children():
		var duplicate_child = child.duplicate()
		new_state.add_child(duplicate_child)
	return new_state

func _init():
	print("GameState created with no information")
