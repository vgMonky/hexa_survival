extends Node2D

var state_manager: StateManager
var focused_entity: Entity  # Track the entity currently in focus

func _ready():
	# Initialize StateManager
	state_manager = StateManager.new()
	state_manager.connect("game_state_changed", self, "_on_game_state_changed")
	
	# Create and apply events
	var map_event = MapEvent.new(2, 2)
	state_manager.change_game_state(map_event)
	
	var char_event1 = CharacterEvent.new("Tom", Vector2(0, 0))
	state_manager.change_game_state(char_event1)
	var char_event2 = CharacterEvent.new("Harry", Vector2(0, 0))  # This should trigger a warning
	state_manager.change_game_state(char_event2)
	var char_event3 = CharacterEvent.new("Alice", Vector2(1, 1))  # Check for walkable
	state_manager.change_game_state(char_event3)
	
	# Set initial focused entity (e.g., the first one added to the game state)
	focused_entity = state_manager.get_current_game_state().game_entities[0]

func _process(_delta):
	if state_manager:
		# Handle direction change
		if Input.is_action_just_pressed("ui_left"):
			input_printing("ui_left")
			_change_direction(focused_entity, -1)  # Rotate counter-clockwise
		elif Input.is_action_just_pressed("ui_right"):
			input_printing("ui_right")
			_change_direction(focused_entity, 1)  # Rotate clockwise
		
		# Handle moving forward
		if Input.is_action_just_pressed("ui_up"):
			input_printing("ui_up")
			_move_forward(focused_entity, 1)  # Move forward by 1 tile
		
		# Print the game state when "ui_accept" is pressed
		if Input.is_action_just_pressed("ui_accept"):
			input_printing("ui_accept")
			state_manager.get_current_game_state().print_state()

func input_printing(action: String):
	print("\n ---> user input: ", action)

func _change_direction(entity: Entity, delta: int):
	if entity.components.has("DirectionComponent"):
		# Create and apply a ChangeDirectionEvent
		var event = ChangeDirectionEvent.new(entity, delta)
		state_manager.change_game_state(event)
		
		# Get components for printing
		var name_component: GivenNameComponent = entity.components["GivenNameComponent"]
		var direction_component: DirectionComponent = entity.components["DirectionComponent"]
		var position_component: PositionComponent = entity.components["PositionComponent"]
		
		# Calculate the adjacent position
		var adjacent_position = PositionSystem.get_adjacent_position(position_component.position, direction_component.current_direction)
		var tile_exists = PositionSystem.hex_tile_exists(state_manager.get_current_game_state(), adjacent_position)
		
		# Print entity info
		print(name_component.given_name, " is now facing direction ", direction_component.current_direction)
		if tile_exists:
			print("Adjacent hex tile: ", adjacent_position)
			if PositionSystem.is_valid_position(state_manager.get_current_game_state(), adjacent_position):
				print("Tile is valid for movement.")
			else:
				print("Tile exists but is either occupied or not walkable.")
		else:
			print("Adjacent hex tile: ", adjacent_position, " (non-existing hex_tile)")
	else:
		print("Entity does not have a DirectionComponent!")

func _move_forward(entity: Entity, amount: int):
	if entity.components.has("PositionComponent") and entity.components.has("DirectionComponent"):
		# Get the position and direction components
		var position_component: PositionComponent = entity.components["PositionComponent"]
		var direction_component: DirectionComponent = entity.components["DirectionComponent"]
		
		# Calculate the adjacent position based on current direction
		var offset = HexDirections.ALL_DIRECTIONS[direction_component.current_direction]
		var intended_position = position_component.position + offset * amount
		
		# Check if the intended position is valid
		var tile_exists = PositionSystem.hex_tile_exists(state_manager.get_current_game_state(), intended_position)
		
		# Print entity info before moving
		var name_component: GivenNameComponent = entity.components["GivenNameComponent"]
		print(name_component.given_name, " is attempting to move forward to ", intended_position)
		
		if tile_exists:
			print("Intended hex tile exists at: ", intended_position)
			
			# Check if the tile is walkable or occupied
			if PositionSystem.is_valid_position(state_manager.get_current_game_state(), intended_position):
				print("Tile is valid for movement. Moving...")
				# Apply the MoveForwardEvent
				var event = MoveForwardEvent.new(entity, amount)
				state_manager.change_game_state(event)
				
				# Print new position after movement
				print(name_component.given_name, "'s new position is ", position_component.position)
			else:
				print("Tile exists but is either occupied or not walkable.")
		else:
			print("Intended hex tile does not exist at: ", intended_position)
	else:
		print("Entity does not have PositionComponent or DirectionComponent!")

func _on_game_state_changed(_new_state):
	print("Signal received: Game state has changed!\n")
