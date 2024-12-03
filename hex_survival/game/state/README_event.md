State Management Documentation
Overview
The state management system provides a predictable way to manage game data through three main components:

GameState: Holds game data and provides query methods
StateManager: Manages state changes and updates
StateChange: Represents a single state modification

GameState
GameState has two main responsibilities:

Store game data (map, entities, resources, etc.)
Provide query methods for safe data access

gdscript
