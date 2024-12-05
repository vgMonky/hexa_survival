#!/usr/bin/env bash

# Define core files
core_files=(
    "./hex_survival/game/state/state_manager.gd"
    "./hex_survival/game/state/game_state.gd"
    "./hex_survival/game/events/map_events.gd"
)

# Define README files
readme_files=(
    "./README.md"
    "./hex_survival/game/events/README_event.md"
    "./hex_survival/game/state/README_state.md"
    "./hex_survival/game/data/README_data.md"
    "./hex_survival/game/systems/README_systems.md"
)

output=$(
    echo "# Hex-Based Game Project Overview"
    echo "I'm working on a hex-based game with minimal state management and clean separation of concerns."
    
    echo -e "\n## Project Structure"
    tree
    
    echo -e "\n## Documentation Files"
    for file in "${readme_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "\n=== $file ==="
            cat "$file"
        fi
    done
    
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
)

echo "$output"

echo "$output" | xclip -selection clipboard
if [ $? -eq 0 ]; then
    echo -e "\n✓ Successfully copied to clipboard!"
else
    echo -e "\n✗ Failed to copy to clipboard"
fi
