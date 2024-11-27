class_name TurnSystem
extends Node

signal turn_started(character)
signal turn_ended(character)  # We'll emit this in end_current_turn
signal round_ended

var state_manager: StateManager
var characters: Array = []  # All characters in order
var current_character_index: int = -1
var is_turn_active: bool = false
var round_count: int = 0
var turn_count: int = 0

func _init(manager: StateManager) -> void:
	state_manager = manager
	print("Turn System initialized")

func initialize_characters(red_team: Array, pink_team: Array) -> void:
	characters = red_team + pink_team
	print("Turn order initialized with ", characters.size(), " characters")
	for i in range(characters.size()):
		var _character = characters[i]  # Added underscore
		print("Turn ", i + 1, ": ", "Red" if i < red_team.size() else "Pink", " team character")

# Add the missing function that the timer is trying to call
func end_current_turn() -> void:
	if not is_turn_active:
		return
		
	is_turn_active = false
	var current_character = characters[current_character_index]
	print("Ending turn for character at position: ", current_character.position)
	emit_signal("turn_ended", current_character)  # Now we emit the signal
	next_turn()

func start_game() -> void:
	print("\nStarting game turns...")
	current_character_index = -1
	round_count = 1
	turn_count = 0
	next_turn()

func next_turn() -> void:
	if is_turn_active:
		print("Turn still active, waiting...")
		return
		
	current_character_index += 1
	if current_character_index >= characters.size():
		current_character_index = 0
		round_count += 1
		print("\nRound ", round_count, " started")
		emit_signal("round_ended")
	
	turn_count += 1
	var current_character = characters[current_character_index]
	is_turn_active = true
	print("\nStarting turn ", turn_count, " (Round ", round_count, ")")
	emit_signal("turn_started", current_character)
