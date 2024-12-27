extends Node2D

func _ready():
	# Create an instance of StateManager
	var state_manager = StateManager.new()
	
	# Connect the signal `game_state_changed` to `_on_game_state_changed`
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	var map_event = MapEvent.new(10, 15)
	state_manager.change_game_state(map_event)

	var char_event = CharacterEvent.new("Tom")
	state_manager.change_game_state(char_event)
	
	
	
	# Print the updated game state
	print("GameState Total nodes count = ", state_manager._current_game_state.get_children().size())
	for child in state_manager._current_game_state.get_children():
		print_node_properties(child)
		
	# Print all characters in the game state
	print_all_characters(state_manager)
	
	
	
func _on_game_state_changed(_new_state):
	print("Signal received: Game state has changed!")

func print_node_properties(node: Node) -> void:
	print("\nProperties for node:", node.name)
	
	# Get all properties of the node
	var properties = node.get_property_list()
	
	# Print the actual class name
	print("Class name: ", node.get_class())  # This will print the class name
	for property in properties:
		# Filter out built-in properties, only show script variables
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var value = node.get(property["name"])
			print("  ", property["name"], " = ", value)

func print_all_characters(state : StateManager):
	# Assuming _current_game_state is accessible here
	if state._current_game_state == null:
		print("No game state available!")
		return
	
	print("Printing all characters in the game state:")

	# Get all children of the game state (which should include characters)
	for child in state._current_game_state.get_children():
		# Check if the child is a Character node
		if child is Character:
			print("Character: ", child.suren)  # Access the suren property of Character




