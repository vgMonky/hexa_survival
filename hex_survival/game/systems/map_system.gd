# game/systems/map_system.gd
class_name MapSystem
extends BaseSystem

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"generate_map":
			return _generate_map(current_state, event)
	return {}

func _generate_map(_state: GameState, event: Dictionary) -> Dictionary:
	var hexes = {}
	for q in range(event.width):
		for r in range(event.height):
			hexes[Vector2(q, r)] = {
				"position": Vector2(q, r),
				"entity": null
			}
	
	return {
		"type": "generate_map",
		"width": event.width,
		"height": event.height,
		"hexes": hexes
	}
