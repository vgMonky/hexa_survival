extends Node
class_name GameState

func _init():
	pass

func print_state():
	print("GameState Total nodes count = ", self.get_children().size())
	for node in self.get_children():
		print("\nProperties for node:", node.name)
	
		# Get all properties of the node
		var properties = node.get_property_list()
		
		# Print the actual class name
		print("Class name: ", node.get_class())  # This will print the class name
		for property in properties:
			# Filter out built-in properties, only show script variables
			if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
				var value = node.get(property["name"])
				print("  ", property["name"], " = ", value)
