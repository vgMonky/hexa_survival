extends Node
class_name Entity

var _class_name : String = "Entity"
var components: Dictionary = {}  # Stores components attached to the entity by type


func _ready():
	if _class_name == "Entity":
		push_error("ERROR: Entity does not have valid _class_name, add it to its definition!")
		
func get_class_name():
	return _class_name
		
# Method to add a component to this entity
func add_component(component: Component):
	var component_class = component.get_class_name()
	
	# Check if the key already exists in the components dictionary
	if components.has(component_class):
		print("Warning: Component of class", component_class, "already exists in entity. Overwriting it!")
	else:
		print("Component added:", component_class)
	# Add the component to the dictionary
	components[component_class] = component
	# Print the current state of the components list
	print("components list:", components)

