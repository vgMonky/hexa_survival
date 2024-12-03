# View System Documentation

The View system is responsible for providing visual representation of the game state and handling user interactions. It operates independently from the game logic but connects with StateManager to display and modify the game state.

## Structure

```
view/
├── map/          # Map visualization
│   ├── hex_view.gd           # Individual hex rendering
│   ├── map_view.gd          # Complete map display
│   └── map_view_container.gd # Map view management
└── ui/           # User interface
    ├── base_ui_panel.gd      # Base UI components
    └── game_info_panel.gd    # Game information display
```

## Responsibilities

1. **Visual Representation**
   - Renders current game state
   - Updates when state changes
   - Handles visual effects and animations

2. **User Interaction**
   - Captures user input
   - Triggers appropriate events
   - Provides feedback to user actions

## State Connection
```gdscript
# Connect to state changes
func _ready():
    state_manager.connect("state_updated", self, "_on_state_updated")

# Update view when state changes
func _on_state_updated():
    var map_data = state_manager.current_state.get_map_size()
    update_display(map_data)
```

## Best Practices

1. Use state queries for data access
2. Trigger events for state changes
3. Keep visualization logic separate from game logic
4. Handle user input validation before triggering events
