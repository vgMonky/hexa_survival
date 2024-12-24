class_name CharacterEvents
extends Reference

class CreateCharacterHandler extends Reference:
	var position: Vector2

	func _init(pos: Vector2) -> void:
		position = pos

	func process(state: GameState) -> Dictionary:
		# Check if the hex at the position is walkable (not occupied by another character)
		if not Query.get_map().is_hex_walkable(state, position):
			print("Cannot create character: Position (%s,%s) is not walkable." % [position.x, position.y])
			return {}  # Return empty dictionary to indicate failure

		# Make sure the map has the hex at the position
		if not Query.get_map().has_hex_at(state, position):
			return {}

		# Calculate the next available character ID
		var next_id = "char_1"  # Default ID if no characters exist
		if state.characters.size() > 0:
			# Get the highest existing character ID and increment it
			var ids = state.characters.keys()
			var max_id = 0
			for id in ids:
				var id_number = int(id.replace("char_", ""))  # Extract the number from the ID
				max_id = max(max_id, id_number)  # Find the highest ID number
			next_id = "char_" + str(max_id + 1)  # Increment the ID number

		# Create the character with the generated ID
		var character = Character.new(next_id)

		# Add the position component
		var position_component = PositionComponent.new(position)
		character.add_component("position", position_component)

		# Add the character to the state
		if not ("characters" in state):  # Check if 'characters' key exists in state
			state.characters = {}  # Initialize the 'characters' dictionary if it doesn't exist

		state.characters[character.id] = character.to_dict()  # Add character to the dictionary

		# Print the character's details to confirm it was created
		print("Character created with ID: %s at position: %s" % [character.id, position])

		return {
			"type": "create_character",
			"character_id": character.id,
			"position": position
		}

# Utility function to create a state change for character creation
static func create_character(pos: Vector2) -> StateChange:
	var handler = CreateCharacterHandler.new(pos)
	return StateChange.new(handler, "process")
