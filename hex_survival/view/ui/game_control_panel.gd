class_name GameControlPanel
extends BaseUIPanel

var state_manager: StateManager
var width_spinbox: SpinBox
var height_spinbox: SpinBox
var create_button: Button
var update_button: Button

func _init(sm: StateManager) -> void:
	state_manager = sm
	._init("Game Control")  # Call parent _init with title
	
	# Create main container for controls
	var vbox = VBoxContainer.new()
	vbox.add_constant_override("separation", 10)
	content_container.add_child(vbox)
	
	# Width control
	var width_container = HBoxContainer.new()
	vbox.add_child(width_container)
	
	var width_label = Label.new()
	width_label.text = "Width:"
	width_container.add_child(width_label)
	
	width_spinbox = SpinBox.new()
	width_spinbox.min_value = 3
	width_spinbox.max_value = 20
	width_spinbox.value = state_manager.current_state.map_data.width  # Set to current width
	width_container.add_child(width_spinbox)
	
	# Height control
	var height_container = HBoxContainer.new()
	vbox.add_child(height_container)
	
	var height_label = Label.new()
	height_label.text = "Height:"
	height_container.add_child(height_label)
	
	height_spinbox = SpinBox.new()
	height_spinbox.min_value = 3
	height_spinbox.max_value = 20
	height_spinbox.value = state_manager.current_state.map_data.height  # Set to current height
	height_container.add_child(height_spinbox)
	
	# Buttons
	var button_container = HBoxContainer.new()
	button_container.add_constant_override("separation", 10)
	vbox.add_child(button_container)
	
	create_button = Button.new()
	create_button.text = "Create New Map"
	create_button.connect("pressed", self, "_on_create_pressed")
	button_container.add_child(create_button)
	
	update_button = Button.new()
	update_button.text = "Randomize Biomes"
	update_button.connect("pressed", self, "_on_update_pressed")
	button_container.add_child(update_button)

func _on_create_pressed() -> void:
	var width = int(width_spinbox.value)
	var height = int(height_spinbox.value)
	state_manager.initialize(width, height)

func _on_update_pressed() -> void:
	state_manager.apply_state_change(MapEvents.set_biomes())
