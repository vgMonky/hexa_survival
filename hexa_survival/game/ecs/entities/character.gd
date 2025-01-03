extends Entity
class_name CharacterEntity

func _init(surname: String, position: Vector2):
	self._class_name = "CharacterEntity"
	
	# Create and add the SurenameComponent to the character
	var given_name_component = GivenNameComponent.new(surname)
	add_component(given_name_component)

	# Create and add the PositionComponent to the character
	var position_component = PositionComponent.new(position)
	add_component(position_component)
	
	print("Character ", surname, " created at position ", position)
