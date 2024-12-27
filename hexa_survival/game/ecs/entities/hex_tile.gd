extends Entity
class_name HexTile

func _init(position: Vector2):
	# Create and attach the PositionComponent to this HexTile entity
	var position_component = PositionComponent.new(position)
	add_component(position_component)
