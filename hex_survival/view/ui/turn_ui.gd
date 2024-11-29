# view/ui/turn_ui.gd
class_name TurnUI
extends UIBox

var round_label: Label
var actions_label: Label
var end_turn_button: Button
var state_manager: StateManager
var turn_order_container: VBoxContainer  # New container for turn order

func _init(title: String = "Turn Info", pos_preset: int = Control.PRESET_TOP_LEFT) -> void:
	._init(title, pos_preset)
	set_margins(10, 10, 200)
	
	# Round info
	round_label = Label.new()
	content.add_child(round_label)
	
	# Turn order container
	turn_order_container = VBoxContainer.new()
	content.add_child(turn_order_container)
	
	# Actions left
	actions_label = Label.new()
	content.add_child(actions_label)
	
	content.add_child(HSeparator.new())
	
	# End turn button
	end_turn_button = Button.new()
	end_turn_button.text = "End Turn"
	end_turn_button.connect("pressed", self, "_on_end_turn_pressed")
	content.add_child(end_turn_button)

func initialize(manager: StateManager) -> void:
	state_manager = manager
	update_turn_info(state_manager.current_state)

func _on_state_updated() -> void:
	update_turn_info(state_manager.current_state)

func update_turn_info(state: GameState) -> void:
	round_label.text = "Round: %d" % state.turn_data.current_round
	actions_label.text = "Moves Left: %d" % state.turn_data.moves_left
	
	# Clear previous turn order display
	for child in turn_order_container.get_children():
		child.queue_free()
	
	# Add header
	var header = Label.new()
	header.text = "\nTurn Order:"
	turn_order_container.add_child(header)
	
	# Display turn order
	for i in range(state.turn_data.turn_order.size()):
		var char_id = state.turn_data.turn_order[i]
		var char_data = state.entities.characters[char_id]
		var team_data = state.teams.team_data[char_data.team]
		
		# Create horizontal container for character info
		var h_box = HBoxContainer.new()
		h_box.add_constant_override("separation", 10)
		turn_order_container.add_child(h_box)
		
		# Add character view
		var char_view = TurnCharacterView.new(char_data, team_data.color)
		char_view.set_active(i == state.turn_data.current_turn_index)
		h_box.add_child(char_view)
		
		# Add character label
		var char_label = Label.new()
		char_label.text = "%s (%s)" % [
			char_data.nickname,
			char_id.split("_")[-1]
		]
		char_label.modulate = team_data.color
		h_box.add_child(char_label)

func _on_end_turn_pressed() -> void:
	if state_manager:
		state_manager.apply_state_change({
			"type": "next_turn"
		})
