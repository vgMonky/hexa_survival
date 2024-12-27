extends Node2D

func _ready():
	# Create an instance of StateManager
	var state_manager = StateManager.new()
	# Connect the signal `game_state_changed` to `_on_game_state_changed`
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	# Event testing
	var map_event = MapEvent.new(3, 3)
	state_manager.change_game_state(map_event)

	var char_event = CharacterEvent.new("Tom")
	state_manager.change_game_state(char_event)
	
	var char_event2 = CharacterEvent.new("Harry")
	state_manager.change_game_state(char_event2)
	
	
	# Print the updated game state
	state_manager.get_current_game_state().print_state()
		
	# Print all characters in the game state
	print_all_characters(state_manager)
	
	
	
func _on_game_state_changed(_new_state):
	print("Signal received: Game state has changed!")


func print_all_characters(state : StateManager):
	# Assuming _current_game_state is accessible here
	if state._current_game_state == null:
		print("No game state available!")
		return
	
	print("Printing all characters in the game state:")

	# Get all children of the game state (which should include characters)
	for child in state.get_current_game_state().get_children():
		# Check if the child is a Character node
		if child is Character:
			print("Character: ", child.surename)  # Access the suren property of Character




