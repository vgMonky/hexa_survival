# In game/ecs/entities/hex_tile.gd

extends Entity
class_name HexTile

func _init(position: Vector2, biome_name: String, color: Color, resources: Dictionary):
	# Create and attach the PositionComponent to this HexTile entity
	var position_component = PositionComponent.new(position)
	add_component(position_component)
	
	# Create and attach the BiomeComponent to this HexTile entity
	var biome_component = BiomeComponent.new(biome_name, color, resources)
	add_component(biome_component)

	print("HexTile created at position:", position, "with biome:", biome_name)
