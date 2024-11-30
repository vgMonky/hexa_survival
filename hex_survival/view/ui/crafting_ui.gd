# view/ui/crafting_ui.gd
class_name CraftingUI
extends UIBox

const ITEM_ICONS = {
	"wooden_sword": preload("res://hex_survival/view/assets/items/sword.png"),
	"wooden_shield": preload("res://hex_survival/view/assets/items/shield.jpg")
}

var state_manager: StateManager
var current_char_label: Label
var status_label: Label
var items_container: VBoxContainer
var equipment_container: VBoxContainer

func _init(title: String = "Crafting", pos_preset: int = Control.PRESET_CENTER_LEFT).(title, pos_preset) -> void:
	set_margins(10, 200, 200)
	
	# Current character info
	current_char_label = Label.new()
	content.add_child(current_char_label)
	
	# Status label for resources
	status_label = Label.new()
	content.add_child(status_label)
	
	# Equipment container
	equipment_container = VBoxContainer.new()
	content.add_child(equipment_container)
	
	content.add_child(HSeparator.new())
	
	# Container for craftable item buttons
	var craftable_label = Label.new()
	craftable_label.text = "Available Items:"
	content.add_child(craftable_label)
	
	items_container = VBoxContainer.new()
	content.add_child(items_container)

func initialize(manager: StateManager) -> void:
	state_manager = manager
	update_ui()
	state_manager.connect("state_updated", self, "_on_state_updated")

func update_ui() -> void:
	# Update current character info
	var current_char_id = _get_current_character_id()
	if current_char_id.empty():
		current_char_label.text = "No character's turn"
		status_label.text = ""
		_clear_craft_buttons()
		return
		
	var char_data = state_manager.current_state.entities.characters[current_char_id]
	var team_data = state_manager.current_state.teams.team_data[char_data.team]
	
	# Update character label
	current_char_label.text = "Current Character: %s (%s)\nTeam: %s" % [
		char_data.nickname,
		current_char_id,
		char_data.team
	]
	
	# Update status (resources)
	status_label.text = "\nTeam Resources:\n"
	for resource in team_data.get("inventory", {}):
		status_label.text += "%s: %d\n" % [resource, team_data.inventory[resource]]
	
	# Clear old equipment
	for child in equipment_container.get_children():
		child.queue_free()
		
	# Add equipment header
	var equip_header = Label.new()
	equip_header.text = "\nEquipment (%d/%d slots):" % [
		char_data.equipment.size(),
		char_data.max_equipment  # Use the value directly from character data
	]
	equipment_container.add_child(equip_header)
	
	# Add equipment items
	if char_data.equipment.empty():
		var none_label = Label.new()
		none_label.text = "None"
		equipment_container.add_child(none_label)
	else:
		for item in char_data.equipment:
			var h_box = HBoxContainer.new()
			h_box.add_constant_override("separation", 5)
			equipment_container.add_child(h_box)
			
			# Add icon
			if ITEM_ICONS.has(item.id):
				var icon = TextureRect.new()
				icon.texture = ITEM_ICONS[item.id]
				icon.rect_min_size = Vector2(16, 16)  # Smaller than craft buttons
				icon.expand = true
				icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				h_box.add_child(icon)
			
			# Add item name
			var item_label = Label.new()
			item_label.text = item.name
			h_box.add_child(item_label)
			
	# Update craft buttons
	_update_craft_buttons(team_data)

func _get_current_character_id() -> String:
	if state_manager.current_state.turn_data.turn_order.empty():
		return ""
	return state_manager.current_state.turn_data.turn_order[
		state_manager.current_state.turn_data.current_turn_index
	]

func _clear_craft_buttons() -> void:
	for child in items_container.get_children():
		child.queue_free()

func _update_craft_buttons(team_data: Dictionary) -> void:
	_clear_craft_buttons()
	
	for item_id in state_manager.crafting_system.CRAFTABLE_ITEMS:
		var item_data = state_manager.crafting_system.CRAFTABLE_ITEMS[item_id]
		
		# Create button container for icon and cost
		var h_box = HBoxContainer.new()
		h_box.add_constant_override("separation", 10)  # Add some spacing
		items_container.add_child(h_box)
		
		# Create and add item icon
		if ITEM_ICONS.has(item_id):
			var icon = TextureRect.new()
			icon.texture = ITEM_ICONS[item_id]
			icon.rect_min_size = Vector2(32, 32)  # Set icon size
			icon.expand = true
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			h_box.add_child(icon)
		
		# Create the craft button
		var button = Button.new()
		var cost_text = ""
		var can_craft = true
		
		# Check if we have enough resources
		for resource in item_data.costs:
			var required = item_data.costs[resource]
			var available = team_data.get("inventory", {}).get(resource, 0)
			cost_text += " (%d/%d %s)" % [available, required, resource]
			if available < required:
				can_craft = false
		
		button.text = item_data.name + cost_text
		button.disabled = not can_craft
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h_box.add_child(button)
		
		# Connect button signal
		button.connect("pressed", self, "_on_craft_item", [item_id])

func _on_craft_item(item_id: String) -> void:
	var current_char_id = _get_current_character_id()
	if current_char_id.empty():
		return
		
	print("[Crafting UI] Crafting %s for character %s" % [item_id, current_char_id])
	
	state_manager.apply_state_change({
		"type": "craft_item",
		"character_id": current_char_id,
		"item_id": item_id
	})

func _on_state_updated() -> void:
	update_ui()
