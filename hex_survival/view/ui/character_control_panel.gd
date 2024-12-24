class_name CharacterControlPanel
extends BaseUIPanel

var state_manager: StateManager
var character_list_container: VBoxContainer
var create_character_button: Button
var character_position_x_spinbox: SpinBox
var character_position_y_spinbox: SpinBox
var character_color_picker: ColorRect

func _init(sm: StateManager) -> void:
	state_manager = sm
	._init("Character Control")  # Call parent _init with title
	
	# Create main container for controls
	var vbox = VBoxContainer.new()
	vbox.add_constant_override("separation", 10)
	content_container.add_child(vbox)
	
	# Character List
	var character_list_label = Label.new()
	character_list_label.text = "Current Characters:"
	vbox.add_child(character_list_label)

	character_list_container = VBoxContainer.new()
	vbox.add_child(character_list_container)

	# Create Character Form
	var create_form_label = Label.new()
	create_form_label.text = "Create New Character:"
	vbox.add_child(create_form_label)

	# X Position control
	var position_x_container = HBoxContainer.new()
	vbox.add_child(position_x_container)
	
	var x_label = Label.new()
	x_label.text = "X Position:"
	position_x_container.add_child(x_label)
	
	character_position_x_spinbox = SpinBox.new()
	character_position_x_spinbox.min_value = 0
	character_position_x_spinbox.max_value = 20
	position_x_container.add_child(character_position_x_spinbox)
	
	# Y Position control
	var position_y_container = HBoxContainer.new()
	vbox.add_child(position_y_container)
	
	var y_label = Label.new()
	y_label.text = "Y Position:"
	position_y_container.add_child(y_label)
	
	character_position_y_spinbox = SpinBox.new()
	character_position_y_spinbox.min_value = 0
	character_position_y_spinbox.max_value = 20
	position_y_container.add_child(character_position_y_spinbox)

	# Color Picker for character
	var color_container = HBoxContainer.new()
	vbox.add_child(color_container)
	
	var color_label = Label.new()
	color_label.text = "Character Color:"
	color_container.add_child(color_label)

	character_color_picker = ColorRect.new()
	character_color_picker.color = Color(1, 0, 0)  # Red by default
	color_container.add_child(character_color_picker)

	# Button to create a new character
	create_character_button = Button.new()
	create_character_button.text = "Create New Character"
	create_character_button.connect("pressed", self, "_on_create_character_pressed")
	vbox.add_child(create_character_button)
	
	# Initial character list update
	_update_character_list()

func _on_create_character_pressed() -> void:
	# Get the position and color from the form
	var position = Vector2(character_position_x_spinbox.value, character_position_y_spinbox.value)
	var character_color = character_color_picker.color
	
	# Call state manager or events to create a new character
	var character_id = "char_" + str(OS.get_ticks_msec())  # Using current time as ID for uniqueness
	state_manager.add_character(character_id, position, character_color)  # This function needs to be implemented in your state_manager

	# Update the character list after creating a new character
	_update_character_list()

func _update_character_list() -> void:
	# Clear the existing character list
	for child in character_list_container.get_children():
		child.queue_free()
	
	# Populate the list with current characters
	for character in state_manager.current_state.characters.values():
		var label = Label.new()
		label.text = "ID: %s | Position: %s" % [character.id, character.components.get("position").get("position")]
		character_list_container.add_child(label)

