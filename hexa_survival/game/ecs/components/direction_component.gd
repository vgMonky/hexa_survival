# File: hexa_survival/game/ecs/components/direction_component.gd

extends Component
class_name DirectionComponent

var current_direction: int = 0  # 0 to 5

func _init(initial_direction: int = 0):
	self._class_name = "DirectionComponent"
	self.current_direction = clamp(initial_direction, 0, 5)

func change_direction(delta: int):
	# Update the direction and wrap it around the 0-5 range
	current_direction = (current_direction + delta) % 6
	print("DirectionComponent: New direction is ", current_direction)
