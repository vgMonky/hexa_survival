# In character_event.gd

extends Event
class_name CharacterEvent

var surname: String
var position: Vector2

func _init(sname: String, pos: Vector2):
	surname = sname
	position = pos

func apply_to_game_state(game_state: GameState) -> GameState:
	print("CharacterEvent: Attempting to add character ", surname, " at position ", position)
	
	# Use PositionSystem to validate the position
	var position_system = PositionSystem.new()
	if not position_system.is_valid_position(game_state, position):
		print("CharacterEvent: Cannot add character at position ", position, " - invalid position.")
		return game_state  # Return the unchanged game state
	
	# If valid, create and add the character entity
	var character = CharacterEntity.new(surname, position)
	game_state.add_entity(character)
	
	print("CharacterEvent: Character ", surname, " added successfully at position ", position)
	return game_state
