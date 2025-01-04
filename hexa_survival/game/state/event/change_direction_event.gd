# File: hexa_survival/game/state/event/change_direction_event.gd

extends Event
class_name ChangeDirectionEvent

var entity: Entity
var direction_delta: int

func _init(target_entity: Entity, delta: int):
	entity = target_entity
	direction_delta = delta

func apply_to_game_state(game_state: GameState) -> GameState:
	print("ChangeDirectionEvent: Attempting to change direction of entity ", entity)

	# Ensure the entity has a DirectionComponent
	if not entity.components.has("DirectionComponent"):
		print("ChangeDirectionEvent: Entity does not have a DirectionComponent.")
		return game_state

	# Change the direction
	var direction_component: DirectionComponent = entity.components["DirectionComponent"]
	direction_component.change_direction(direction_delta)

	print("ChangeDirectionEvent: Direction changed successfully for entity ", entity)
	return game_state
