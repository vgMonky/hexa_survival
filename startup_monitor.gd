# startup_monitor.gd
extends Node

const DEBUG_STARTUP = false  # Set to true to see startup timing

func _init():
	if DEBUG_STARTUP:
		print("TIMING: Autoload _init start")

func _enter_tree():
	if DEBUG_STARTUP:
		print("TIMING: Autoload enter tree")

func _ready():
	if DEBUG_STARTUP:
		print("TIMING: Autoload ready")

func _notification(what):
	if DEBUG_STARTUP:
		match what:
			NOTIFICATION_INSTANCED:
				print("TIMING: Autoload instanced")
			NOTIFICATION_PREDELETE:
				print("TIMING: Autoload predelete")
