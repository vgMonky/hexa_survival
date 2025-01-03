extends Node2D

var state_manager : StateManager

func _ready():
	# Create an instance of StateManager
	state_manager = StateManager.new()
	# Connect the signal `game_state_changed` to `_on_game_state_changed`
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	# Event testing
	var map_event = MapEvent.new(2, 2)
	state_manager.change_game_state(map_event)

	var char_event = CharacterEvent.new("Tom", Vector2(10, 20))
	state_manager.change_game_state(char_event)
	
	var char_event2 = CharacterEvent.new("Harry", Vector2(15, 25))
	state_manager.change_game_state(char_event2)
	
	
func _process(_delta):
	if state_manager:
		# Detect the "p" key press (you can change this to any key you like)
		if Input.is_action_just_pressed("ui_accept"):  # You can map "p" in the Input Map for better control
			# Trigger the state print when the "p" key is pressed
			state_manager.get_current_game_state().print_state()
	
	
func _on_game_state_changed(_new_state):
	print("Signal received: Game state has changed!\n")

