# view/ui/turn_ui.gd
class_name TurnUI
extends UIBox

var current_turn_label: Label
var round_label: Label
var actions_label: Label
var end_turn_button: Button
var state_manager: StateManager

func _init(title: String = "Turn Info", pos_preset: int = Control.PRESET_TOP_LEFT) -> void:
	._init(title, pos_preset)
	set_margins(10, 10, 200)
	
	# Round info
	round_label = Label.new()
	content.add_child(round_label)
	
	# Current turn info
	current_turn_label = Label.new()
	content.add_child(current_turn_label)
	
	# Actions left
	actions_label = Label.new()
	content.add_child(actions_label)
	
	content.add_child(HSeparator.new())
	
	# End turn button
	end_turn_button = Button.new()
	end_turn_button.text = "End Turn"
# warning-ignore:return_value_discarded
	end_turn_button.connect("pressed", self, "_on_end_turn_pressed")
	content.add_child(end_turn_button)

func initialize(manager: StateManager) -> void:
	state_manager = manager
	update_turn_info(state_manager.current_state)

func _on_state_updated() -> void:
	print("[TurnUI] Updating turn info")
	update_turn_info(state_manager.current_state)

func update_turn_info(state: GameState) -> void:
	var current_char_id = state.turn_data.turn_order[state.turn_data.current_turn_index]
	var current_char = state.entities.characters[current_char_id]
	var team_color = state.teams.team_data[current_char.team].color
	
	round_label.text = "Round: %d" % state.turn_data.current_round
	current_turn_label.text = "Current Turn: %s\nTeam: %s" % [current_char_id, current_char.team]
	current_turn_label.modulate = team_color
	actions_label.text = "Moves Left: %d" % state.turn_data.moves_left

func _on_end_turn_pressed() -> void:
	if state_manager:
		print("[TurnUI] End turn pressed")
		state_manager.apply_state_change({
			"type": "next_turn"
		})
