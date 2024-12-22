# Query System

A centralized interface for accessing game state data safely and consistently.

## Usage

```gdscript
# Access map data
var hex = Query.get_map().get_hex_at(state, position)
var walkable = Query.get_map().is_hex_walkable(state, position)

# Future usage examples:
# var entity = Query.get_entity().get_by_id(state, entity_id)
# var items = Query.get_inventory().get_items(state, entity_id)
```

## Design Goals

- Single entry point for all state queries
- Pure functions (no state modification)
- Safe access with error handling
- Easy to extend with new query types
