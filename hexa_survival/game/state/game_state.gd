extends Node
class_name GameState

var game_map : Map
var game_entities : Array = []

func _init():
	pass

# Print the current state of the game (map and entities)
func print_state():
	print("\n__________Print_Game_State___________")
	
	# Print game map details if it exists
	if game_map:
		print("\nGame Map:")
		#print_object_properties(game_map, 1)
	
	# Print all entities in the game state
	if game_entities.size() > 0:
		print("\nGame Entities:")
		for entity in game_entities:
			print("\n")
			print_object_properties(entity, 1)
	else:
		print("No entities in the game state.")


# Add the map to game state
func set_map(map: Map):
	game_map = map

# Add an entity to the game state
func add_entity(entity: Entity):
	game_entities.append(entity)

# Print object properties (recursively)
func print_object_properties(obj, indent_level: int):
	var properties = obj.get_property_list()
	var indent = "  ".repeat(indent_level)
	
	for property in properties:
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var value = obj.get(property["name"])
			print(indent + property["name"], " = ", value)

			if value is Dictionary:
				for key in value:
					print(indent + "  Key:", key)
					if value[key] is Object:
						if value[key].has_method("components"):
							print(indent + "  Components for key:", key)
							var components_dict = value[key].components
							for comp_type in components_dict:
								var component = components_dict[comp_type]
								print(indent + "    Component:", comp_type)
								print_object_properties(component, indent_level + 3)
						else:
							print_object_properties(value[key], indent_level + 2)
