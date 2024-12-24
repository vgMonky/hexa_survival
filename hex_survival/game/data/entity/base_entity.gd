# data/entity/base_entity.gd
class_name Entity
extends Reference

var id: String
var components: Dictionary = {}

func _init() -> void:
	pass

func add_component(component_name: String, component: Component) -> void:
	components[component_name] = component

func get_component(component_name: String) -> Component:
	return components.get(component_name)

func has_component(component_name: String) -> bool:
	return components.has(component_name)

func to_dict() -> Dictionary:
	var dict = {
		"id": id,
		"components": {}
	}
	for comp_name in components:
		dict["components"][comp_name] = components[comp_name].to_dict()
	return dict

func from_dict(dict: Dictionary) -> void:
	id = dict["id"]
	components = {}
	for comp_name in dict["components"]:
		var comp = Component.new()
		comp.from_dict(dict["components"][comp_name])
		components[comp_name] = comp
