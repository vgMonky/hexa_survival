extends System
class_name MovementSystem

# Change direction of an entity
func change_direction(entity: Entity, delta: int) -> void:
	# Ensure the entity has a DirectionComponent
	var direction_component: DirectionComponent = entity.get_component("DirectionComponent")
	if not direction_component:
		print("MovementSystem: Entity does not have a DirectionComponent.")
		return
	
	# Update the direction
	direction_component.current_direction = (direction_component.current_direction + delta) % 6
	if direction_component.current_direction < 0:
		direction_component.current_direction += 6
	
	print("MovementSystem: Entity's direction updated to ", direction_component.current_direction)
