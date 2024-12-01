class_name HexTile
extends Reference

var position: Vector2
var biome: String = ""
var biome_data: Dictionary = {}
var entity_id = null

func _init(pos: Vector2) -> void:
	position = pos

func set_biome(biome_type: String) -> void:
	biome = biome_type
	biome_data = BiomeTypes.get_data(biome_type)

func to_dict() -> Dictionary:
	return {
		"position": position,
		"biome": biome,
		"biome_data": biome_data,
		"entity": entity_id
	}
