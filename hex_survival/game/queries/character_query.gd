# game/queries/character_query.gd
class_name CharacterQuery
extends Reference

static func get_character(state: GameState, id: String) -> Dictionary:
	return state.characters.get(id, {})

static func get_all_characters(state: GameState) -> Array:
	return state.characters.values()
