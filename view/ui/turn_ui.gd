class_name TurnUI
extends UIBox

var turn_label: Label
var current_character: Character = null
var turn_system: TurnSystem  # Add reference to turn system

func _init(ts: TurnSystem).("Turn Information", Control.PRESET_TOP_LEFT) -> void:
	turn_system = ts
	set_margins(10, 10, 200)
	
	# Create label
	turn_label = Label.new()
	turn_label.text = "Waiting for game to start..."
	
	# Add to container
	content_container.add_child(turn_label)
	print("Turn UI initialized")

func _on_turn_started(character: Character) -> void:
	current_character = character
	var team_name = "Red" if character.team_color == Color.red else "Pink"
	turn_label.text = "Round: %d | Turn: %d\n" % [turn_system.round_count, turn_system.turn_count]
	turn_label.text += team_name + " Team's Turn\n"
	turn_label.text += "Character at: " + str(character.position)
	print("Turn UI updated for new turn")

func _on_turn_ended(_character: Character) -> void:
	current_character = null
	turn_label.text = "Processing next turn..."
	print("Turn UI updated for turn end")

func _on_round_ended() -> void:
	turn_label.text = "Round %d completed\nStarting new round..." % turn_system.round_count
	print("Turn UI updated for round end")
