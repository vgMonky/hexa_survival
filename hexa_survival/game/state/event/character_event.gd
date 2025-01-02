extends Event
class_name CharacterEvent

var surname: String
var position: Vector2

func _init(sname: String, pos: Vector2):
	surname = sname
	position = pos

func apply_to_game_state(game_state: GameState) -> GameState:
	print("CharacterEvent: Adding character ", surname, " to the game state")
	
	# Create a new Character node and pass surname and position
	var character = Character.new(surname, position)
	game_state.add_child(character)
	return game_state
