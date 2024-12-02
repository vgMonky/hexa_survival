# view/ui/game_info_panel.gd
class_name GameInfoPanel
extends BaseUIPanel

var state_manager: StateManager
var info_label: Label

func _init(sm: StateManager) -> void:
	state_manager = sm
	._init("Game Info")  # Call parent _init with title
	
	# Create and add info label
	info_label = Label.new()
	content_container.add_child(info_label)
	
	# Connect to state changes
	state_manager.connect("state_updated", self, "_on_state_updated")
	
	# Initial update
	_update_info()

func _on_state_updated() -> void:
	_update_info()

func _update_info() -> void:
	var text = ""
	var map_data = state_manager.current_state.map_data
	
	# Map size
	text += "Map Size: %dx%d\n" % [map_data.width, map_data.height]
	
	# Count biomes
	var biome_counts = {}
	for hex in map_data.hexes.values():
		var biome = hex.biome
		if not biome_counts.has(biome):
			biome_counts[biome] = 0
		biome_counts[biome] += 1
	
	# Display biome counts
	text += "\nBiome Distribution:\n"
	for biome in biome_counts:
		text += "%s: %d\n" % [biome, biome_counts[biome]]
	
	info_label.text = text
