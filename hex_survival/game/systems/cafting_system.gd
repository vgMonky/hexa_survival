# game/systems/crafting_system.gd
class_name CraftingSystem
extends BaseSystem

const CRAFTABLE_ITEMS = {
	"wooden_sword": {
		"name": "Wooden Sword",
		"type": "weapon",
		"damage": 2,
		"costs": {
			"wood": 3
		}
	},
	"wooden_shield": {
		"name": "Wooden Shield", 
		"type": "shield",
		"defense": 1,
		"costs": {
			"wood": 2
		}
	}
}

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"craft_item":
			return _process_craft_item(current_state, event)
	return {}

func _process_craft_item(state: GameState, event: Dictionary) -> Dictionary:
	var character_id = event.character_id
	var item_id = event.item_id
	
	# Validate item exists
	if not CRAFTABLE_ITEMS.has(item_id):
		push_error("Invalid item: " + item_id)
		return {}
	
	# Get character and team data
	var character = state.entities.characters[character_id]
	var team_data = state.teams.team_data[character.team]
	
	# Check if character has room for more equipment
	if character.equipment.size() >= character.max_equipment:
		push_error("Character equipment slots full")
		return {}
	
	# Check if team has required resources
	var item_data = CRAFTABLE_ITEMS[item_id]
	for resource in item_data.costs:
		var required = item_data.costs[resource]
		var available = team_data.get("inventory", {}).get(resource, 0)
		if available < required:
			push_error("Insufficient resources: " + resource)
			return {}
	
	# Create updated team inventory
	var new_inventory = team_data.get("inventory", {}).duplicate()
	for resource in item_data.costs:
		new_inventory[resource] -= item_data.costs[resource]
	
	# Create updated character equipment
	var new_equipment = character.equipment.duplicate()
	new_equipment.append({
		"id": item_id,
		"name": item_data.name,
		"type": item_data.type,
		"stats": item_data
	})
	
	return {
		"type": "craft_item",
		"character_id": character_id,
		"team": character.team,
		"new_inventory": new_inventory,
		"new_equipment": new_equipment
	}
