# state_change.gd
class_name StateChange
extends Reference

var _handler: Object
var _method: String

func _init(handler_obj: Object, method_name: String):
	_handler = handler_obj
	_method = method_name

func execute(state: GameState) -> Dictionary:
	return _handler.call(_method, state)
