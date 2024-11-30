class_name ItemRegistry
extends Reference

var items: Dictionary = {}

func register_item(item: BaseItem) -> void:
	items[item.id] = item

func get_item(item_id: String) -> BaseItem:
	return items.get(item_id)

func has_item(item_id: String) -> bool:
	return items.has(item_id)
