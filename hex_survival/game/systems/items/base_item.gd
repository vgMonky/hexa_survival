# game/systems/items/base_item.gd
class_name BaseItem
extends Reference

var id: String
var name: String
var type: String
var costs: Dictionary
var stats: Dictionary
var ability: Dictionary

func _init() -> void:
	id = ""
	name = "Unknown Item"
	type = "misc"
	costs = {}
	stats = {}
	ability = {}

func initialize(item_id: String, config: Dictionary) -> void:
	id = item_id
	name = config.get("name", "Unknown Item")
	type = config.get("type", "misc")
	costs = config.get("costs", {})
	stats = config.get("stats", {})
	ability = config.get("ability", {})

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"type": type,
		"stats": stats
	}
