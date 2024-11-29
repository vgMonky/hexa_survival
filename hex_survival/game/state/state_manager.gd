# game/state/state_manager.gd
class_name StateManager
extends Node

signal state_updated

var current_state: GameState
var next_entity_id: int = 0

# Systems
var team_system: TeamSystem
var map_system: MapSystem
var biome_system: BiomeSystem
var character_system: CharacterSystem
var turn_system: TurnSystem
var movement_system: MovementSystem
var resource_system: ResourceSystem

func _init() -> void:
	print("TIMING: StateManager _init start")
	team_system = TeamSystem.new()
	map_system = MapSystem.new()
	biome_system = BiomeSystem.new()
	character_system = CharacterSystem.new()
	turn_system = TurnSystem.new()
	movement_system = MovementSystem.new()
	resource_system = ResourceSystem.new()
	print("TIMING: StateManager _init complete")

func initialize(width: int, height: int) -> void:
	print("TIMING: StateManager initialize start")
	randomize()
	current_state = GameState.new(width, height)
	print("TIMING: State initialized with size: ", width, "x", height)

	# Generate initial map
	apply_state_change({
		"type": "generate_map",
		"width": width,
		"height": height
	})
	print("TIMING: StateManager initialize complete")

func get_new_entity_id() -> int:
   next_entity_id += 1
   return next_entity_id - 1

func apply_state_change(event: Dictionary) -> void:
   var changes = _process_event(event)
   if changes.empty():
	   return
	   
   var new_state = _apply_changes(changes)
   if new_state:
	   current_state = new_state
	   emit_signal("state_updated")
	   print("State updated: ", changes.type)

func _process_event(event: Dictionary) -> Dictionary:
	print("Processing event type: ", event.type)
	match event.type:
		"add_team":
			print("[Team] Creating: ", event.team_name)
			var team_result = team_system.process_event(current_state, event)
			if team_result.empty():
				print("[Team] Failed to create")
				return {}
			
			return team_result # Just return team creation result
			
		"create_character":
			print("[Character] Creating character with nickname: ", event.nickname)
			var character_result = character_system.process_event(current_state, event)
			if character_result.empty():
				print("[Character] Failed to create")
				return {}
			
			# Apply character changes
			var char_state = _apply_changes(character_result)
			if char_state:
				current_state = char_state
				# Initialize/update turn order with new character
				return turn_system.process_event(current_state, {"type": "initialize_turn_order"})
			return {}
			
		"move_character":
			print("[State Manager] Processing move")
			var result = movement_system.process_event(current_state, event)
			print("[State Manager] Move result:", result)
			return result
			
		"next_turn":
			var turn_result = turn_system.process_event(current_state, event)
			if turn_result.empty():
				return {}
				
			# Apply turn changes
			var new_state = _apply_changes(turn_result)
			if new_state:
				current_state = new_state
				
			# Process resource collection after turn change
			var collection_result = resource_system.process_event(current_state, event)
			if not collection_result.empty():
				return collection_result
			
			return turn_result
			
		"collect_resources":
			return event
			
		"add_character":
			return character_system.process_event(current_state, event)
			
		"generate_map":
			var map_result = map_system.process_event(current_state, event)
			if map_result.empty():
				return {}
			return biome_system.process_event(current_state, map_result)
			
		"get_valid_moves":
			return movement_system.process_event(current_state, event)
			
			
	return {}

func _apply_changes(changes: Dictionary) -> GameState:
	print("[State Manager] Applying changes of type:", changes.type)
	var new_state = GameState.new(current_state.map_data.width, current_state.map_data.height)
	
	# Copy existing data
	new_state.teams = current_state.teams.duplicate(true)
	new_state.entities = current_state.entities.duplicate(true)
	new_state.turn_data = current_state.turn_data.duplicate(true)
	new_state.map_data = current_state.map_data.duplicate(true)
	
	match changes.type:
		"initialize_turn_order":
			print("Initializing turn order")
			print("Turn order: ", changes.turn_order)
			new_state.turn_data.turn_order = changes.turn_order
			new_state.turn_data.current_turn_index = changes.current_turn_index
			new_state.turn_data.current_round = changes.current_round
			new_state.turn_data.moves_left = MovementSystem.MAX_HEX_STEPS
		
		"move_character":
			print("[State Manager] Before move - moves_left:", new_state.turn_data.moves_left)
			# Update character position
			new_state.entities.characters[changes.character_id].position = changes.new_position
			# Update hex entities
			new_state.map_data.hexes[changes.old_position].entity = null
			new_state.map_data.hexes[changes.new_position].entity = changes.character_id
			# Update moves_left with the new value
			new_state.turn_data.moves_left = changes.moves_left
			print("[State Manager] After move - moves_left:", new_state.turn_data.moves_left)
			
		"next_turn":
			new_state.turn_data.current_turn_index = changes.current_turn_index
			new_state.turn_data.current_round = changes.current_round
			new_state.turn_data.moves_left = MovementSystem.MAX_HEX_STEPS 
		
		"add_team":
			print("Adding team to state: ", changes.team_name)
			new_state.teams.team_data[changes.team_name] = {"color": changes.team_color}
			new_state.teams.members[changes.team_name] = []
		   
		"add_character":
			# Update entities
			new_state.entities.characters[changes.character_id] = {
				"id": changes.character_id,
				"nickname": changes.nickname,
				"team": changes.team,
				"position": changes.position,
				"max_life": character_system.CHARACTER_CONFIG.max_life,
				"current_life": changes.life,
				"equipment": changes.equipment
			}
			
			# Update team members
			if not new_state.teams.members.has(changes.team):
				new_state.teams.members[changes.team] = []
			new_state.teams.members[changes.team].append(changes.character_id)
			
			# Update hex entity reference
			new_state.map_data.hexes[changes.position].entity = changes.character_id
	 
		
		"add_team_characters":
			print("Adding team characters to state for team: ", changes.team_name)
			print("Characters to add: ", changes.characters.keys())
			
			# Ensure team exists
			if not new_state.teams.team_data.has(changes.team_name):
				push_error("Team does not exist: " + changes.team_name)
				return null
			
			# Add characters to entities and team members
			for char_id in changes.characters:
				new_state.entities.characters[char_id] = changes.characters[char_id]
				new_state.teams.members[changes.team_name].append(char_id)
				print("Added character: ", char_id, " to team: ", changes.team_name)
			
			# Update hex entities
			for char_pos in changes.character_positions:
				new_state.map_data.hexes[char_pos.position].entity = char_pos.character_id
				print("Updated hex at position: ", char_pos.position, " with entity: ", char_pos.character_id)
		
		"generate_map":
			new_state.map_data.width = changes.width
			new_state.map_data.height = changes.height
			new_state.map_data.hexes = changes.hexes
			
		"collect_resources":
			print("[State] Applying resource collections")
			# Initialize team inventories if they don't exist
			for team_name in changes.collections.keys():
				if not new_state.teams.team_data[team_name].has("inventory"):
					new_state.teams.team_data[team_name]["inventory"] = {}
					
			# Add collected resources to team inventories
			for team_name in changes.collections:
				var team_collections = changes.collections[team_name]
				for resource_type in team_collections:
					if not new_state.teams.team_data[team_name]["inventory"].has(resource_type):
						new_state.teams.team_data[team_name]["inventory"][resource_type] = 0
					new_state.teams.team_data[team_name]["inventory"][resource_type] += team_collections[resource_type]
					print("[State] Team %s now has %d %s" % [
						team_name,
						new_state.teams.team_data[team_name]["inventory"][resource_type],
						resource_type
					])
			
			
	return new_state
