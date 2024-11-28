# game/systems/resource_system.gd
class_name ResourceSystem
extends BaseSystem

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"next_turn":
			return _process_resource_collection(current_state)
	return {}

func _process_resource_collection(state: GameState) -> Dictionary:
	print("\n=== Resource Collection Phase ===")
	print("Processing end-of-turn resource collection...")
	var collection_results = {}
	
	# Process each character's collection attempt
	for char_id in state.entities.characters:
		var char_data = state.entities.characters[char_id]
		var hex_data = state.map_data.hexes[char_data.position]
		var resources = hex_data.biome_data.resources
		var biome_type = hex_data.biome
		
		print("\nCharacter %s (Team: %s)" % [char_id, char_data.team])
		print("Current hex: %s at position %s" % [biome_type, char_data.position])
		print("Available resources: %s" % resources)
		
		# Initialize team's collection results if not exists
		if not collection_results.has(char_data.team):
			collection_results[char_data.team] = {}
			
		# Try to collect each resource type
		for resource_type in resources:
			var chance = resources[resource_type]
			if _try_collect(chance):
				print("SUCCESS: Collected %s (%.1f%% chance)" % [resource_type, chance * 100])
				if not collection_results[char_data.team].has(resource_type):
					collection_results[char_data.team][resource_type] = 0
				collection_results[char_data.team][resource_type] += 1
			else:
				print("FAILED: Did not collect %s (%.1f%% chance)" % [resource_type, chance * 100])

	print("\n=== Team Inventories ===")
	for team_name in state.teams.team_data:
		var inventory = state.teams.team_data[team_name].get("inventory", {})
		print("%s inventory: %s" % [team_name, inventory])
	print("========================\n")

	# If we collected anything, return the changes
	if not collection_results.empty():
		return {
			"type": "collect_resources",
			"collections": collection_results
		}
	
	return {}

func _try_collect(chance: float) -> bool:
	randomize()
	return randf() < chance
