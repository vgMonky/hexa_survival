# game/systems/map_system.gd
class_name MapSystem
extends BaseSystem

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"generate_map":
			return _generate_map_structure(current_state, event)
	return {}

func _generate_map_structure(_state: GameState, event: Dictionary) -> Dictionary:
	# Validate map dimensions
	if event.width <= 0 or event.height <= 0:
		push_error("Invalid map dimensions")
		return {}
	
	# Create basic hex structure
	var hexes = {}
	for q in range(event.width):
		for r in range(event.height):
			hexes[Vector2(q, r)] = {
				"position": Vector2(q, r),
				"entity": null,
				"biome": null,
				"biome_data": null
			}
	
	return {
		"type": "generate_map",
		"width": event.width,
		"height": event.height,
		"hexes": hexes
	}
