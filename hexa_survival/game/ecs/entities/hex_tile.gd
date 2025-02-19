extends Entity
class_name HexTileEntity


func _init(position: Vector2, biome_name: String, color: Color, resources: Dictionary, is_walkable: bool):
	self._class_name = "HexTileEntity"
	
	# Create and attach the PositionComponent to this HexTile entity
	var position_component = PositionComponent.new(position)
	add_component(position_component)
	
	# Create and attach the BiomeComponent to this HexTile entity
	var biome_component = BiomeComponent.new(biome_name, color, resources, is_walkable)
	add_component(biome_component)

	print("HexTile created at position:", position, "with biome:", biome_name)
