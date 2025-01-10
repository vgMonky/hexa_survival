extends Event
class_name MoveForwardEvent

var entity: Entity
var amount: int

func _init(target_entity: Entity, move_amount: int):
	entity = target_entity
	amount = move_amount

func apply_to_game_state(game_state: GameState) -> GameState:
	print("MoveForwardEvent: Attempting to move entity ", entity)

	# Use MovementSystem to handle the movement
	var movement_system = MovementSystem.new()
	if movement_system:
		movement_system.move_forward(entity, amount)
	else:
		print("MoveForwardEvent: MovementSystem not found in the game state.")
	
	return game_state
