# startup_monitor.gd
extends Node

func _init():
	print("TIMING: Autoload _init start")
	
func _enter_tree():
	print("TIMING: Autoload enter tree")
	
func _ready():
	print("TIMING: Autoload ready")
	
func _notification(what):
	match what:
		NOTIFICATION_INSTANCED:
			print("TIMING: Autoload instanced")
		NOTIFICATION_PREDELETE:
			print("TIMING: Autoload predelete")
