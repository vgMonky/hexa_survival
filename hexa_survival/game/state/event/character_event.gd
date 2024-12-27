# CharacterEvent.gd
extends Event
class_name CharacterEvent

var sname: String

func _init(sn: String):
	sname = sn

func apply_to_game_state(game_state: GameState) -> GameState:
	print("CharacterEvent: Adding character ", sname, " to the game state")

	# Create a new Character node
	var character = Character.new(sname)  # This should be recognized as Character
	game_state.add_child(character)
	return game_state
