# view/ui/turn_character_view.gd
class_name TurnCharacterView
extends Control

const CHARACTER_SIZE = 15  # Smaller than map version
const HIGHLIGHT_PADDING = 3
const HIGHLIGHT_PULSE_SPEED = 2.0

var character_data: Dictionary
var team_color: Color
var is_active: bool = false
var time_passed: float = 0

func _init(char_data: Dictionary, color: Color) -> void:
	character_data = char_data
	team_color = color
	rect_min_size = Vector2(CHARACTER_SIZE + HIGHLIGHT_PADDING * 2, CHARACTER_SIZE + HIGHLIGHT_PADDING * 2)

func _process(delta: float) -> void:
	if is_active:
		time_passed += delta
		update()

func set_active(active: bool) -> void:
	is_active = active
	update()

func _draw() -> void:
	var center = rect_min_size / 2
	
	# Draw highlight if active
	if is_active:
		var highlight_size = Vector2(CHARACTER_SIZE + HIGHLIGHT_PADDING * 2,
								   CHARACTER_SIZE + HIGHLIGHT_PADDING * 2)
		var highlight_pos = center - highlight_size / 2
		
		# Create pulsing effect
		var pulse = (sin(time_passed * HIGHLIGHT_PULSE_SPEED) + 1) / 2
		var highlight_color = Color.magenta
		highlight_color.a = 0.5 + (0.2 * pulse)
		
		draw_rect(Rect2(highlight_pos, highlight_size), highlight_color)
	
	# Draw character
	var rect_size = Vector2(CHARACTER_SIZE, CHARACTER_SIZE)
	var rect_pos = center - rect_size / 2
	draw_rect(Rect2(rect_pos, rect_size), team_color)
	draw_rect(Rect2(rect_pos, rect_size), Color.black, false, 1.0)
