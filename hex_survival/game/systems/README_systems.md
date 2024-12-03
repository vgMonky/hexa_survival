# System Documentation

Systems are pure logic modules that contain reusable calculations and validations, primarily used by Events.

## Purpose

- Contain game logic separate from state management
- Provide pure functions (same input always produces same output)
- Handle calculations and validations
- Never modify state directly

## Example: MapSystem

```gdscript
class MapSystem:
    # Pure function to check if position exists
    static func can_transform_biome(hexes: Dictionary, position: Vector2) -> bool:
        return hexes.has(position)

    # Pure function to create hex with new biome
    static func create_hex_with_biome(hex_data: Dictionary, biome_type: String) -> Dictionary:
        var new_hex = hex_data.duplicate(true)
        new_hex.biome = biome_type
        new_hex.biome_data = BiomeTypes.get_data(biome_type)
        return new_hex
```

## Usage in Events

```gdscript
func process(state: GameState) -> Dictionary:
    # Systems provide calculations and validations
    if not MapSystem.can_transform_biome(state.map_data.hexes, position):
        return {}
        
    # Systems help create new data
    var new_hex = MapSystem.create_hex_with_biome(hex_data, new_biome)
```

## Best Practices

1. Keep functions pure (no side effects)
2. Return new data instead of modifying
3. Use for complex calculations and validations
4. Keep system functions focused and reusable
