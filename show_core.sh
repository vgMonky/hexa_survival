# Save as show_core.sh
#!/bin/bash

# Define core files
core_files=(
    "./hex_survival/game/state/state_manager.gd"
    "./hex_survival/game/state/game_state.gd"
    "./hex_survival/game/events/map_events.gd"
    "./hex_survival/game/data/map.gd"
    "./hex_survival/game/data/hex_tile.gd"
    "./hex_survival/main.gd"
)

# Print overview
echo "# Hex-Based Game Project Overview"
echo "I'm working on a hex-based game with minimal state management and clean separation of concerns."
echo -e "\n## Project Structure"
tree
echo -e "\n## Core Architecture Files"
for file in "${core_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "\n=== $file ==="
        cat "$file"
    fi
done
echo -e "\n## Key Design Principles"
echo "- Minimal state management through events"
echo "- Clean separation of concerns"
echo "- Data-driven design"
