# game/systems/crafting_system.gd
class_name CraftingSystem
extends BaseSystem

var item_registry: ItemRegistry

func _init() -> void:
	item_registry = ItemRegistry.new()
	_register_items()

func _register_items() -> void:
	item_registry.register_item(WoodenSword.new())
	item_registry.register_item(WoodenShield.new())

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"craft_item":
			return _process_craft_item(current_state, event)
	return {}

func _process_craft_item(state: GameState, event: Dictionary) -> Dictionary:
	var character_id = event.character_id
	var item_id = event.item_id
	
	# Validate item exists
	if not item_registry.has_item(item_id):
		push_error("Invalid item: " + item_id)
		return {}
	
	var item = item_registry.get_item(item_id)
	
	# Get character and team data
	var character = state.entities.characters[character_id]
	var team_data = state.teams.team_data[character.team]
	
	# Check if character has room for more equipment
	if character.equipment.size() >= character.max_equipment:
		push_error("Character equipment slots full")
		return {}
	
	# Check if team has required resources
	for resource in item.costs:
		var required = item.costs[resource]
		var available = team_data.get("inventory", {}).get(resource, 0)
		if available < required:
			push_error("Insufficient resources: " + resource)
			return {}
	
	# Create updated team inventory
	var new_inventory = team_data.get("inventory", {}).duplicate()
	for resource in item.costs:
		new_inventory[resource] -= item.costs[resource]
	
	# Create updated character equipment
	var new_equipment = character.equipment.duplicate()
	new_equipment.append(item.to_dict())
	
	return {
		"type": "craft_item",
		"character_id": character_id,
		"team": character.team,
		"new_inventory": new_inventory,
		"new_equipment": new_equipment
	}
