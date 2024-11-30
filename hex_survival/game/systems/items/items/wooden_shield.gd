# wooden_shield.gd
class_name WoodenShield
extends BaseItem

func _init():
	._init()  # Call parent _init() instead of super()
	initialize(
		"wooden_shield",
		{
			"name": "Wooden Shield",
			"type": "shield", 
			"costs": {"wood": 2},
			"stats": {"defense": 1},
			"ability": {
				"name": "Block",
				"description": "Chance to block incoming damage",
				"event": "shield_block"
			}
		}
	)
