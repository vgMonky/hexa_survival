extends Node2D

var state_manager: StateManager

func _ready():
	# Initialize StateManager
	state_manager = StateManager.new()
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	# Create and apply events
	var map_event = MapEvent.new(2, 2)
	state_manager.change_game_state(map_event)
	
	var char_event1 = CharacterEvent.new("Tom", Vector2(0, 0))
	state_manager.change_game_state(char_event1)
	var char_event2 = CharacterEvent.new("Harry", Vector2(0, 0))  # This should trigger a warning
	state_manager.change_game_state(char_event2)
	var char_event3 = CharacterEvent.new("Alice", Vector2(1, 1))  # Check for walkable
	state_manager.change_game_state(char_event3)
	var char_event4 = CharacterEvent.new("Olice", Vector2(0, 1))  # Check for walkable
	state_manager.change_game_state(char_event4)
	var char_event5 = CharacterEvent.new("Rice", Vector2(1, 0))  # Check for walkable
	state_manager.change_game_state(char_event5)
	var char_event6 = CharacterEvent.new("Jaice", Vector2(3, 3))  # Check for walkable
	state_manager.change_game_state(char_event6)

func _process(_delta):
	if state_manager:
		if Input.is_action_just_pressed("ui_accept"):
			state_manager.get_current_game_state().print_state()

func _on_game_state_changed(_new_state):
	print("Signal received: Game state has changed!\n")
