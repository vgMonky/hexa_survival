extends Event

class_name CharacterEvent

var surename: String

func _init(sn):
	surename = sn

func apply_to_game_state(game_state: GameState) -> GameState:
	
	
	print("CharacterEvent: Adding character ", surename , " to the game state")
	
	# Create a new Map node
	var character = Character.new(surename)
	# Add it to the GameState
	game_state.add_child(character)
	
	return game_state
