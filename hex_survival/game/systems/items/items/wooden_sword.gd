# wooden_sword.gd
class_name WoodenSword
extends BaseItem

func _init():
	._init()  # Call parent _init() instead of super()
	initialize(
		"wooden_sword", 
		{
			"name": "Wooden Sword",
			"type": "weapon",
			"costs": {"wood": 3},
			"stats": {"damage": 2},
			"ability": {
				"name": "Sword Attack",
				"description": "Basic melee attack",
				"event": "sword_attack"
			}
		}
	)
