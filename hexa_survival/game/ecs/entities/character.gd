# File: hexa_survival/game/ecs/entities/character.gd

extends Entity
class_name CharacterEntity

func _init(surname: String, position: Vector2, initial_direction: int = 0):
	self._class_name = "CharacterEntity"
	
	# Add SurenameComponent
	var given_name_component = GivenNameComponent.new(surname)
	add_component(given_name_component)

	# Add PositionComponent
	var position_component = PositionComponent.new(position)
	add_component(position_component)
	
	# Add DirectionComponent
	var direction_component = DirectionComponent.new(initial_direction)
	add_component(direction_component)
	
	print("Character ", surname, " created at position ", position, " facing direction ", initial_direction)
