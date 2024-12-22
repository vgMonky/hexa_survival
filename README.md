# Hex Survival

A turn-based strategy game built in Godot 3.5.2 where players control teams of characters collecting resources and moving on a hexagonal grid map.


## Architecture

The game state consist of a dictionary which is the single source of truth, and everything else works either by reading or applaying a change to the `game_state` through the `state_manager`.
The visualisation is isolated from the game model it self, recating to the game state every time it changes. 
The game follows an Entity-Component-System (ECS) inspired pattern.

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
- UI elements


## Running the Game

Requires Godot 3.5.2. Open the project in Godot and run the main scene.

