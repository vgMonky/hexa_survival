# game/queries/query.gd
class_name Query
extends Reference

# Base Query class that provides a consistent interface for all queries
# Each query type (Map, Entity, etc.) will extend this class

static func get_map():
	return MapQuery

static func get_char():
	return CharacterQuery
