extends Component
class_name PositionComponent

var position: Vector2  # The position of the tile (or any entity)

func _init(p: Vector2):
	self._class_name = "PositionComponent"
	
	self.position = p
	
	
