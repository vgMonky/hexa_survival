# CharacterEvent.gd
extends Event
class_name CharacterEvent

var surename: String

func _init(sn: String):
	surename = sn

func apply_to_game_state(game_state: GameState) -> GameState:
	print("CharacterEvent: Adding character ", surename, " to the game state")

	# Create a new Character node
	var character = Character.new(surename)  # This should be recognized as Character
	game_state.add_child(character)
	return game_state
