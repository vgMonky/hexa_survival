class_name StateManager
extends Node

signal state_updated

var current_state: GameState
var queries: StateQueries

func _init() -> void:
	print("StateManager initialized")

func initialize(width: int, height: int) -> void:
	current_state = GameState.new(width, height)
	queries = StateQueries.new(self)
	print("State initialized with map size: ", width, "x", height)
	apply_state_change(MapEvents.set_biomes())
	emit_signal("state_updated")

func apply_state_change(event: Dictionary) -> void:
	var changes = _process_event(event)
	if changes.empty():
		return
		
	var new_state = _apply_changes(changes)
	if new_state:
		current_state = new_state
		emit_signal("state_updated")
		print("Applied event: ", event.type)

func _process_event(event: Dictionary) -> Dictionary:
	match event.type:
		MapEvents.SET_BIOMES:
			return MapEvents.process_set_biomes(current_state)
	return {}

func _apply_changes(changes: Dictionary) -> GameState:
	var new_state = GameState.new(current_state.map_data.width, current_state.map_data.height)
	new_state.map_data = current_state.map_data.duplicate(true)
	
	match changes.type:
		MapEvents.SET_BIOMES:
			new_state.map_data.hexes = changes.hexes
			
	return new_state
