# Event System Documentation

The game uses an Event System to handle state changes in a predictable and maintainable way. This document explains how events work and how to create new ones.

## Event Structure

Each event consists of two parts:

1. **Handler Class**: Contains the logic for processing the state change
   ```gdscript
   class ExampleHandler extends Reference:
	   var some_property: int
	   
	   func _init(value: int):
		   some_property = value
		   
	   func process(state: GameState) -> Dictionary:
		   # Make changes to state
		   return {
			   "type": "example_event",
			   "changed_value": some_property
		   }
   ```

2. **Static Function**: Creates and returns a StateChange object
   ```gdscript
   static func example_event(value: int) -> StateChange:
	   var handler = ExampleHandler.new(value)
	   return StateChange.new(handler, "process")
   ```

## Usage

Events are used through the StateManager:
```gdscript
state_manager.apply_state_change(MapEvents.transform_biome(pos, "WOODS"))
```

## Real Example: Transform Biome

Here's a complete example from our MapEvents:

```gdscript
# 1. Handler class
class TransformBiomeHandler extends Reference:
	var position: Vector2
	var new_biome: String
	
	func _init(pos: Vector2, biome: String):
		position = pos
		new_biome = biome
	
	func process(state: GameState) -> Dictionary:
		if not MapSystem.can_transform_biome(state.map_data.hexes, position):
			return {}
			
		var hex_data = state.map_data.hexes[position]
		var new_hex = MapSystem.create_hex_with_biome(hex_data, new_biome)
		state.map_data.hexes[position] = new_hex
		
		return {
			"type": "transform_biome",
			"position": position,
			"old_biome": hex_data.biome,
			"new_biome": new_biome
		}

# 2. Static function
static func transform_biome(pos: Vector2, new_biome: String) -> StateChange:
	var handler = TransformBiomeHandler.new(pos, new_biome)
	return StateChange.new(handler, "process")
```

## Best Practices

1. **System Logic**: Use System classes for calculations and validations
2. **State Changes**: Events should only change state through their process() function
3. **Return Values**: Always return a dictionary with at least a "type" field
4. **Validation**: Return empty dictionary {} if the event can't be processed
5. **Properties**: Use handler properties for data needed during processing

## When to Use Events

Events are particularly useful when:
- Changes need to maintain state between updates
- Complex validations or calculations are needed
- Changes affect multiple parts of the game state
- You need to track or undo changes
