extends Event
class_name CharacterEvent

var surname: String
var position: Vector2

func _init(sname: String, pos: Vector2):
	surname = sname
	position = pos

func apply_to_game_state(game_state: GameState) -> GameState:
	print("CharacterEvent: Adding character ", surname, " to the game state")
	
	# Create a new Entity reference (Character node is no longer necessary)
	var character = CharacterEntity.new(surname, position)
	
	# Add the entity to the game state
	game_state.add_entity(character)
	
	return game_state
 
