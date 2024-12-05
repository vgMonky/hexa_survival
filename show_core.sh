#!/usr/bin/env bash

# Define core files
core_files=(
    "./hex_survival/game/state/state_manager.gd"
    "./hex_survival/game/state/game_state.gd"
    "./hex_survival/game/events/map_events.gd"
    "./hex_survival/game/data/map.gd"
    "./hex_survival/game/data/hex_tile.gd"
    "./hex_survival/main.gd"
)

# Generate and display the output while simultaneously saving to a variable
output=$(
    echo "# Hex-Based Game Project Overview"
    echo "I'm working on a hex-based game with minimal state management and clean separation of concerns."
    echo -e "\n## Project Structure"
    tree
    echo -e "\n## Core Architecture Files"
    for file in "${core_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "\n=== $file ==="
            cat "$file"
        else
            echo "File not found - $file"
        fi
    done
    echo -e "\n## Key Design Principles"
    echo "- Minimal state management through events"
    echo "- Clean separation of concerns"
    echo "- Data-driven design"
)

# Print the output
echo "$output"

# Copy to clipboard and check if successful
echo "$output" | xclip -selection clipboard
if [ $? -eq 0 ]; then
    echo -e "\n✓ Successfully copied to clipboard!"
else
    echo -e "\n✗ Failed to copy to clipboard"
fi
