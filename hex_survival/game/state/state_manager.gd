# state_manager.gd
class_name StateManager
extends Node

# StateManager's responsibilities:
# 1. Hold the current game state
# 2. Apply state changes through events
# 3. Notify observers when state changes
#
# StateManager should NOT:
# 1. Contain game logic (that goes in events)
# 2. Modify state directly (only through events)
# 3. Handle view/UI logic
# 4. Store temporary/computed data

signal state_updated

var current_state: GameState

func _init() -> void:
	print("StateManager initialized")

func initialize(width: int, height: int) -> void:
	randomize() 
	current_state = GameState.new(width, height)
	print("State initialized with map size: ", width, "x", height)
	apply_state_change(MapEvents.set_biomes())
	emit_signal("state_updated")

func apply_state_change(change: StateChange) -> void:
	var new_state = current_state.duplicate()
	var changes = change.execute(new_state)
	if changes:
		current_state = new_state
		emit_signal("state_updated")
		print("Applied changes: ", changes.type)
