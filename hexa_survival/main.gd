extends Node2D

func _ready():
	# Create an instance of StateManager
	var state_manager = StateManager.new()
	
	# Connect the signal `game_state_changed` to `_on_game_state_changed`
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	var map_event = MapEvent.new(10, 15)
	state_manager.change_game_state(map_event)
	var char_event2 = CharacterEvent.new("Rick")
	state_manager.change_game_state(char_event2)
	
	var char_event = CharacterEvent.new("Tom")
	state_manager.change_game_state(char_event)

func print_node_properties(node: Node) -> void:
	print("\nProperties for node:", node.name)
	
	# Get all properties of the node
	var properties = node.get_property_list()
	
	for property in properties:
		# Filter out built-in properties, only show script variables
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var value = node.get(property["name"])
			print("  ", property["name"], " = ", value)

func _on_game_state_changed(new_state):
	print("Signal received: Game state has changed!")
	# Print the updated game state
	for child in new_state.get_children():
		print("  Child node:", child.name)
		print_node_properties(child)
