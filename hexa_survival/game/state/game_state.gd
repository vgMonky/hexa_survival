extends Node
class_name GameState

func _init():
	pass

func print_state():
	print("GameState Total nodes count = ", self.get_children().size())
	for node in self.get_children():
		print("\nProperties for node:", node.name)
		print_object_properties(node, 0)

func print_object_properties(obj, indent_level: int):
	var properties = obj.get_property_list()
	var indent = "  ".repeat(indent_level)
	
	# Print all script variables for the object
	for property in properties:
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var value = obj.get(property["name"])
			print(indent + property["name"], " = ", value)

			# If it's a Dictionary, handle nested data
			if value is Dictionary:
				for key in value:
					print(indent + "  Key:", key)
					if value[key] is Object:
						# Explicitly print components if found
						if value[key].has_method("components"):
							print(indent + "  Components for key:", key)
							var components_dict = value[key].components
							for comp_type in components_dict:
								var component = components_dict[comp_type]
								print(indent + "    Component:", comp_type)
								print_object_properties(component, indent_level + 3)
						else:
							# Recursively print nested objects
							print_object_properties(value[key], indent_level + 2)
