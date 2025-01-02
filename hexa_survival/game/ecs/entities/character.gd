extends Entity
class_name Character

func _init(surname: String, position: Vector2):
	_class_name = "Character"
	
	# Create and add the SurenameComponent to the character
	var surename_component = SurenameComponent.new(surname)
	add_component(surename_component)

	# Create and add the PositionComponent to the character
	var position_component = PositionComponent.new(position)
	add_component(position_component)
	
	print("Character ", surname, " created at position ", position)
