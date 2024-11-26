class_name TurnManager
extends Node

signal turn_started(character)
signal turn_ended(character)
signal round_ended

var characters: Array = []  # All characters in turn order
var current_character_index: int = -1
var is_turn_active: bool = false

func initialize(red_team: Array, pink_team: Array) -> void:
	# Add red team characters first, then pink team
	characters = red_team + pink_team
	
func start_game() -> void:
	current_character_index = -1
	next_turn()

func next_turn() -> void:
	if is_turn_active:
		return
		
	current_character_index += 1
	if current_character_index >= characters.size():
		current_character_index = 0
		emit_signal("round_ended")
	
	var current_character = characters[current_character_index]
	is_turn_active = true
	emit_signal("turn_started", current_character)
	
	# Wait 1 second then do random move
	yield(get_tree().create_timer(1.0), "timeout")
	_do_random_move(current_character)

func _do_random_move(character: Character) -> void:
	# Get available adjacent hexes
	var possible_moves = get_valid_moves(character)
	
	if not possible_moves.empty():
		# Choose random position
		var new_pos = possible_moves[randi() % possible_moves.size()]
		move_character(character, new_pos)
	
	# End turn
	is_turn_active = false
	emit_signal("turn_ended", character)
	next_turn()

func get_valid_moves(character: Character) -> Array:
	var valid_moves = []
	var current_pos = character.position
	
	# Check all adjacent hexes
	var directions = [
		Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1),
		Vector2(-1, 0), Vector2(0, -1), Vector2(1, -1)
	]
	
	for dir in directions:
		var new_pos = current_pos + dir
		if is_valid_move(character, new_pos):
			valid_moves.append(new_pos)
	
	return valid_moves

func is_valid_move(_character: Character, new_pos: Vector2) -> bool:
	# Check if position exists and is walkable
	var hex_data = get_parent().get_hex_data(new_pos)
	if hex_data.empty() or not hex_data["biome"]["walkable"]:
		return false
	
	# Check if position is occupied
	if hex_data["occupied"] != null:
		return false
	
	return true

func move_character(character: Character, new_pos: Vector2) -> void:
	# Clear old position
	var old_hex = get_parent().hex_data[character.position]
	old_hex["occupied"] = null
	
	# Set new position
	var new_hex = get_parent().hex_data[new_pos]
	new_hex["occupied"] = character
	character.position = new_pos
	
	# Update map
	get_parent().emit_signal("map_updated")
