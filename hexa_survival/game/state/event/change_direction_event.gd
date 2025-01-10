extends Event
class_name ChangeDirectionEvent

var entity: Entity
var direction_delta: int

func _init(target_entity: Entity, delta: int):
	entity = target_entity
	direction_delta = delta

func apply_to_game_state(game_state: GameState) -> GameState:
	print("ChangeDirectionEvent: Attempting to change direction of entity ", entity)

	# Use MovementSystem to handle the direction change
	var movement_system = MovementSystem.new()
	if movement_system:
		movement_system.change_direction(entity, direction_delta)
	else:
		print("ChangeDirectionEvent: MovementSystem not found in the game state.")
	
	return game_state
