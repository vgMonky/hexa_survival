# game/state/state_manager.gd
class_name StateManager
extends Node

signal state_updated

var current_state: GameState
var next_entity_id: int = 0

# Systems
var team_system: TeamSystem = TeamSystem.new()
var map_system: MapSystem = MapSystem.new() 
var biome_system: BiomeSystem = BiomeSystem.new()
var character_system: CharacterSystem = CharacterSystem.new()

func initialize(width: int, height: int) -> void:
   randomize()
   current_state = GameState.new(width, height)
   print("State initialized with size: ", width, "x", height)
   
   # Generate initial map
   apply_state_change({
	   "type": "generate_map",
	   "width": width,
	   "height": height
   })

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
	match event.type:
		"add_team":
			# First create the team
			var team_result = team_system.process_event(current_state, event)
			if team_result.empty():
				return {}
			
			# Apply team changes to get an updated state before creating characters
			var team_state = _apply_changes(team_result)
			if team_state:
				current_state = team_state
			
			# Now create the characters with the updated state
			return character_system.process_event(current_state, event)
			
		"add_character":
			return character_system.process_event(current_state, event)
		"generate_map":
			var map_result = map_system.process_event(current_state, event)
			if map_result.empty():
				return {}
			return biome_system.process_event(current_state, map_result)
	return {}

func _apply_changes(changes: Dictionary) -> GameState:
	var new_state = GameState.new(current_state.map_data.width, current_state.map_data.height)
	
	# Copy existing data
	new_state.teams = current_state.teams.duplicate(true)
	new_state.entities = current_state.entities.duplicate(true)
	new_state.turn_data = current_state.turn_data.duplicate(true)
	new_state.map_data = current_state.map_data.duplicate(true)
	
	# Apply changes
	match changes.type:
		"add_team":
			new_state.teams.team_data[changes.team_name] = {"color": changes.team_color}
			new_state.teams.members[changes.team_name] = []
		
		"add_team_characters":
			# Ensure team exists
			if not new_state.teams.team_data.has(changes.team_name):
				push_error("Team does not exist: " + changes.team_name)
				return null
				
			# Add characters to entities and team members
			for char_id in changes.characters:
				new_state.entities.characters[char_id] = changes.characters[char_id]
				new_state.teams.members[changes.team_name].append(char_id)
			
			# Update hex entities
			for char_pos in changes.character_positions:
				new_state.map_data.hexes[char_pos.position].entity = char_pos.character_id
		
		"generate_map":
			new_state.map_data.width = changes.width
			new_state.map_data.height = changes.height
			new_state.map_data.hexes = changes.hexes
			
	return new_state
