class_name TeamManager
extends Node

var teams: Dictionary = {}  # team_name -> Team

signal team_created(team)
signal character_added(team, character)

func create_team(team_name: String, team_color: Color) -> Team:
	# Check if team name exists
	if teams.has(team_name):
		push_error("Team name '" + team_name + "' already exists!")
		return null
	
	# Check if color is already used
	for team in teams.values():
		if team.team_color.is_equal_approx(team_color):
			push_error("Team color " + str(team_color) + " already in use!")
			return null
	
	# Create new team
	var team = Team.new(team_name, team_color)
	teams[team_name] = team
	add_child(team)
	emit_signal("team_created", team)
	print("Created team: ", team_name)
	return team

func add_character_to_team(team_name: String, state_manager: StateManager) -> Character:
	if not teams.has(team_name):
		push_error("Team '" + team_name + "' does not exist!")
		return null
	
	var team = teams[team_name]
	var character = Character.new()
	add_child(character)
	team.add_character(character)
	if not state_manager.place_entity(character, Vector2.ZERO):
		push_error("Failed to place character for team: " + team_name)
		return null
	emit_signal("character_added", team, character)
	print("Added new character to team: ", team_name)
	return character

func get_team(team_name: String) -> Team:
	return teams.get(team_name)

func get_all_teams() -> Array:
	return teams.values()
