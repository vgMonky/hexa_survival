# Game Data Architecture

This directory contains all data structures used in the game. The architecture follows an Entity Component System (ECS) pattern with three main categories of data structures:

## Static Data
Files that define constant, immutable game configurations and properties:

- `biome_types.gd`: Defines the different types of terrain, their properties, and resource spawn chances
- `hex_tile.gd`: Base structure for hexagonal grid cells
- `map.gd`: Grid structure and organization of hex tiles

Static data serves as the foundation for game rules and mechanics, providing reference values and configurations that remain consistent throughout gameplay.

## Entities (`/entities`)
Entities are dynamic game objects defined by their composition of components. They serve as containers that group related components together to represent a complete game object.

Key characteristics:
- Each entity has a unique identifier
- Entities are just containers - they have no behavior logic
- Their structure is defined dynamically through component composition
- Can be serialized to and from dictionaries for state management

Example: A "Character" entity might combine:
- Position Component (location on map)
- Health Component (current/max health)
- Inventory Component (held items)
- Movement Component (movement range/points)

## Components (`/components`)
Components are individual pieces of data that define specific attributes or capabilities. They are:
- Pure data containers (no game logic)
- Reusable across different entity types
- Independent and focused on a single aspect
- Connected to specific systems that contain their related logic

Example Component Usage:
```gdscript
# HealthComponent could be used by both characters and destructible machines
var character = Character.new("player_1")
character.add_component("health", HealthComponent.new(100))

var machine = Machine.new("extractor_1")
machine.add_component("health", HealthComponent.new(200))
```

## Integration with Systems
While data structures here define "what things are", the actual game logic resides in the systems:
- Movement System operates on Position Components
- Combat System operates on Health Components
- Crafting System operates on Inventory Components

This separation ensures:
1. Clean distinction between data and logic
2. Reusable components across different entity types
3. Easy addition of new capabilities through component composition
4. Simplified state management and serialization
5. Better testability and maintenance

Example Flow:
```
Entity (Character) 
  └─ Components (Position, Health)
      └─ Systems (MovementSystem, CombatSystem) 
          └─ State Changes
```

## State Management Integration
All data structures in this directory are designed to be:
- Serializable to/from dictionaries
- Immutable per frame
- Easy to duplicate for state changes
- Clear about their data ownership
