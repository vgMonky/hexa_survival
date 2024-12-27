extends Node
class_name Entity

var components: Dictionary = {}  # Stores components attached to the entity by type

# Method to add a component to this entity
func add_component(component: Component):
	components[component.get_class()] = component
