# game/systems/character_system.gd
class_name CharacterSystem
extends BaseSystem

class Character:
	var id: String
	var nickname: String
	var team: String
	var position: Vector2
	var max_life: int = 10
	var current_life: int = 10
	var equipment: Array = []

	func _init(char_id: String, char_nickname: String, team_name: String, pos: Vector2) -> void:
		id = char_id
		nickname = char_nickname
		team = team_name
		position = pos
		current_life = max_life

	func to_dict() -> Dictionary:
		return {
			"id": id,
			"nickname": nickname,
			"team": team,
			"position": position,
			"max_life": max_life,
			"current_life": current_life,
			"equipment": equipment
		}

	static func from_dict(data: Dictionary) -> Character:
		var character = Character.new(
			data.id,
			data.nickname,
			data.team,
			data.position
		)
		character.current_life = data.get("current_life", character.max_life)
		character.equipment = data.get("equipment", [])
		return character

const CHARACTER_CONFIG = {
	"max_life": 10
}

func process_event(current_state: GameState, event: Dictionary) -> Dictionary:
	match event.type:
		"add_character":
			return _validate_and_create_character(current_state, event)
		"add_team": # Handle character creation for new team
			return _create_team_characters(current_state, event)
		"create_character":
			return _validate_and_create_character(current_state, event)
	return {}

func _validate_and_create_character(state: GameState, event: Dictionary) -> Dictionary:
	# Validate team exists
	if not state.teams.team_data.has(event.team):
		push_error("Team does not exist: " + event.team)
		return {}
		
	# Find valid position automatically
	var valid_position = _find_single_valid_position(state)
	if valid_position == Vector2(-1, -1):
		push_error("No valid positions available for character")
		return {}
	
	# Generate unique ID based on total existing characters
	var char_id = str(state.entities.characters.size())
	
	# Create character
	var character = Character.new(
		char_id,
		event.nickname,
		event.team,
		valid_position
	)
	
	print("[Character] Created %s ('%s') for team %s at %s" % [
		char_id,
		event.nickname,
		event.team,
		valid_position
	])
	
	return {
		"type": "add_character",
		"character_id": char_id,
		"nickname": event.nickname,
		"team": event.team,
		"position": valid_position,
		"life": character.current_life,
		"equipment": character.equipment
	}
	
func _find_single_valid_position(state: GameState) -> Vector2:
	var all_valid = []
	
	# Collect all valid positions
	for hex_pos in state.map_data.hexes.keys():
		var hex_data = state.map_data.hexes[hex_pos]
		if hex_data.biome_data.walkable and hex_data.entity == null:
			all_valid.append(hex_pos)
	
	if all_valid.empty():
		# Return an invalid position that we can check for
		return Vector2(-1, -1)  # Using -1,-1 as our "invalid" position
		
	# Randomize selection
	randomize()
	all_valid.shuffle()
	
	return all_valid[0]

func _create_team_characters(state: GameState, event: Dictionary) -> Dictionary:
	print("[Characters] Creating for team: ", event.team_name)
	var valid_positions = _find_valid_positions(state, 2)
	if valid_positions.empty():
		print("[Characters] No valid positions found")
		return {}
	
	var characters = {}
	var character_positions = []
	for i in range(2):
		var character_id = str(event.team_name) + "_char_" + str(i)
		# Added "Bot" + number as default nickname for auto-created characters
		var character = Character.new(
			character_id,
			"Bot" + str(i),  # Default nickname
			event.team_name,
			valid_positions[i]
		)
		characters[character_id] = character.to_dict()
		character_positions.append({
			"character_id": character_id,
			"position": valid_positions[i]
		})
		print("[Character] Created %s at %s" % [character_id, valid_positions[i]])
	
	return {
		"type": "add_team_characters",
		"team_name": event.team_name,
		"characters": characters,
		"character_positions": character_positions
	}
	
func _find_valid_positions(state: GameState, count: int) -> Array:
	var valid_positions = []
	var all_valid = []
	
	# First collect all valid positions
	for hex_pos in state.map_data.hexes.keys():
		var hex_data = state.map_data.hexes[hex_pos]
		if hex_data.biome_data.walkable and hex_data.entity == null:
			all_valid.append(hex_pos)
	
	# Randomize selection
	randomize()
	all_valid.shuffle()
	
	# Take the first 'count' positions
	for i in range(min(count, all_valid.size())):
		valid_positions.append(all_valid[i])
	
	return valid_positions
