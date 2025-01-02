extends Reference
class_name Component

var _class_name : String = "Component"

func _ready():
	if _class_name == "Component":
		push_error("ERROR: Component does not have valid _class_name, add it to its definition!")
		
func get_class_name():
	return _class_name
		
