# Hex Survival

A turn-based strategy game built in Godot 3.5.2 where players control teams of characters collecting resources and moving on a hexagonal grid map.


## Architecture

The game follows an Entity-Component-System (ECS) inspired pattern:

### State Layer

- Single source of truth
- Complete game state snapshot
- Map data (grid, biomes)
- Entity data (characters, positions)
- Team data and inventories

### Systems Layer

- Pure logic processors (stateless)
- Process current state
- Output state change requests
- Systems include: Movement, Turn, Resource Collection

### View Layer

- Purely reactive to state
- Handles user input
- UI elements include:
  - Turn order display
  - Team information
  - Resource counters
  - Map visualization

## Project Structure

```
hex_survival/
├── game/
│   ├── data/           # Data structure, Entity and Components
│   ├── state/          # State management
│   ├── systems/        # Game systems Pure logic
│   └── events/         # Events
└── view/
    ├── map/           # Map visualization
    └── ui/            # User interface
```

## Running the Game

Requires Godot 3.5.2. Open the project in Godot and run the main scene.

