# data/components/position_component.gd
class_name PositionComponent
extends Component

var position: Vector2

func _init(pos: Vector2) -> void:
	position = pos

func to_dict() -> Dictionary:
	return {
		"position": {
			"x": position.x,
			"y": position.y
		}
	}

func from_dict(dict: Dictionary) -> void:
	position = Vector2(dict["position"]["x"], dict["position"]["y"])
