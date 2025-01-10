extends Component
class_name DirectionComponent

var current_direction: int = 0  # 0 to 5

func _init(initial_direction: int = 0):
	self._class_name = "DirectionComponent"
	self.current_direction = clamp(initial_direction, 0, 5)
