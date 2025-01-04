extends Reference
class_name Entity

var _class_name: String = "Entity"
var components: Dictionary = {}  # Stores components attached to the entity by type

func _ready():
	if _class_name == "Entity":
		push_error("ERROR: Entity does not have valid _class_name, add it to its definition!")
		
func get_class_name() -> String:
	return _class_name

# Method to add a component to this entity
func add_component(component: Component):
	var component_class = component.get_class_name()

	if components.has(component_class):
		print("Warning: Component of class", component_class, "already exists in entity. Overwriting it!")
		
	components[component_class] = component

# Method to get a specific component by name
func get_component(component_name: String) -> Component:
	if components.has(component_name):
		return components[component_name]
	return null
