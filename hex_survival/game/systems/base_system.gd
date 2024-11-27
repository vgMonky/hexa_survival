# game/systems/base_system.gd
class_name BaseSystem
extends Reference

func process_event(_current_state: GameState, _event: Dictionary) -> Dictionary:
	return {}
