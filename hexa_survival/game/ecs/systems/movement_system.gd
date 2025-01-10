extends System
class_name MovementSystem

# Change direction of an entity
func change_direction(entity: Entity, delta: int) -> void:
	var direction_component: DirectionComponent = entity.get_component("DirectionComponent")
	if not direction_component:
		print("MovementSystem: Entity does not have a DirectionComponent.")
		return
	
	direction_component.current_direction = (direction_component.current_direction + delta) % 6
	if direction_component.current_direction < 0:
		direction_component.current_direction += 6
	
	print("MovementSystem: Entity's direction updated to ", direction_component.current_direction)

# Move an entity forward in its current direction
func move_forward(entity: Entity, amount: int) -> void:
	var position_component: PositionComponent = entity.get_component("PositionComponent")
	var direction_component: DirectionComponent = entity.get_component("DirectionComponent")

	if not position_component or not direction_component:
		print("MovementSystem: Entity does not have PositionComponent or DirectionComponent.")
		return

	# Get the direction offset based on the current direction
	var offset = HexDirections.ALL_DIRECTIONS[direction_component.current_direction]
	# Move the entity forward by the specified amount
	position_component.position += offset * amount
	
	print("MovementSystem: Entity moved to ", position_component.position)
