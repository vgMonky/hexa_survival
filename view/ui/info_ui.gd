class_name InfoUI
extends UIBox

var map_info: Label
var hex_info: Label
var character_info: Label

func _init().("Game Information", Control.PRESET_TOP_RIGHT) -> void:
	set_margins(-200, 10, -10)
	
	# Create labels
	map_info = Label.new()
	hex_info = Label.new()
	character_info = Label.new()
	
	# Add to container
	content_container.add_child(map_info)
	content_container.add_child(hex_info)
	content_container.add_child(character_info)
	
	# Initialize empty
	clear_hex_info()
	print("InfoUI initialized")

func update_map_info(state: GameState) -> void:
	map_info.text = "Map Info:\n"
	map_info.text += "Size: %d x %d\n" % [state.width, state.height]
	map_info.text += "Total Hexes: %d" % len(state.hex_grid)
	print("Map info updated")

func update_hex_info(hex_data: Dictionary, pos: Vector2) -> void:
	if hex_data.empty():
		clear_hex_info()
		return
		
	hex_info.text = "\nHex Info:\n"
	hex_info.text += "Position: (%d, %d)\n" % [pos.x, pos.y]
	if hex_data.has("biome"):
		hex_info.text += "Biome: %s\n" % hex_data["biome"]["biome_name"]
		hex_info.text += "Walkable: %s\n" % ("Yes" if hex_data["biome"]["walkable"] else "No")
		
		# Show resources
		var resources = hex_data["biome"]["resources"]
		if not resources.empty():
			hex_info.text += "Possible Resources:\n"
			for resource in resources:
				var chance = resources[resource] * 100
				hex_info.text += "  %s (%d%%)\n" % [resource, chance]
	
	if hex_data.has("occupied") and hex_data["occupied"] != null:
		var character = hex_data["occupied"]
		character_info.text = "\nCharacter Info:\n"
		character_info.text += "Health: %d\n" % character.health
		character_info.text += "Equipment: %s\n" % (str(character.equipment) if not character.equipment.empty() else "Empty")
	else:
		character_info.text = ""
	
	print("Hex info updated for position: ", pos)

func clear_hex_info() -> void:
	hex_info.text = "\nHover over a hex to see info"
	character_info.text = ""
	print("Hex info cleared")
