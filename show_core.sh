#!/usr/bin/env bash

# Define core files
core_files=(
    "./hexa_survival/game/state/state_manager.gd"
    "./hexa_survival/game/state/game_state.gd"
    "./hexa_survival/game/state/event/base_event.gd"
    "./hexa_survival/game/state/event/map_event.gd"
)

# Define README files
readme_files=(
    "./README.md"
)

output=$(
    echo "# Tile-Grid-Based Game Project Overview"
    echo "I'm working on a tile-grid-based game with minimal state management and clean separation of concerns in godot 3.5 in my nixos system."
    
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
)

echo "$output"

echo "$output" | xclip -selection clipboard
if [ $? -eq 0 ]; then
    echo -e "\n✓ Successfully copied to clipboard!"
else
    echo -e "\n✗ Failed to copy to clipboard"
fi
