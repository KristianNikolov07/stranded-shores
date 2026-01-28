extends VBoxContainer

## The script responsible for the objective system

const OBJECTIVES_FILE_PATH = "res://Assets/Objectives.json"

var objectives = {}
## The objective the player is currently completing
var current_objective = "movement"

func _ready() -> void:
	parse_objectives()
	update_ui()


## Parses the objectives from the objectives from the OBJECTIVES_FILE_PATH and puts them
## in the objectives variable
func parse_objectives() -> void:
	var file = FileAccess.open(OBJECTIVES_FILE_PATH, FileAccess.READ)
	objectives = JSON.parse_string(file.get_as_text())
	file.close()


## Sets the objective the player is currently completing
func set_objective(objective : String) -> void:
	if objective in objectives:
		current_objective = objective
		update_ui()


## Updates the UI that displayes the current objective
func update_ui() -> void:
	var description : String = tr(objectives[current_objective]["description"])
	var regex = RegEx.new()
	regex.compile(r"(?<=CONTROL\()[^)]+(?=\))")
	for action in regex.search_all(description):
		if InputMap.has_action(action.get_string()) and InputMap.action_get_events(action.get_string()).size() > 0:
			var event = InputMap.action_get_events(action.get_string())[0]
			var keybind = event.as_text().replace("(Physical)", "").lstrip(" ").rstrip(" ")
			description = description.replace("CONTROL(" + action.get_string() + ")", keybind)
	
	$Description.text = description


## Attempts the complete an objective. If the current_objective matches 
## the string passed to the function,
## the current_objective is set to the next objective
func complete_objective(objective : String) -> void:
	if current_objective == objective:
		if objectives[current_objective]["next_objective"] != "":
			set_objective(objectives[current_objective]["next_objective"])
		else:
			hide()


## Used for the objectives that require the player to have specific item/items in order
## to be completed
func check_item() -> void:
	var player : Player = Global.get_player()
	if objectives[current_objective]["type"] == "item":
		for requirement in objectives[current_objective]["requirements"]:
			if player.inventory.has_item(requirement.item_name, requirement.amount) == false:
				return
		complete_objective(current_objective)


## Used for the objectives that require the player to place specific structure in order
## to be completed
func check_structure_place(structure_item_name : String) -> void:
	if objectives[current_objective]["type"] == "place_a_structure":
		if objectives[current_objective]["structure_item_name"] == structure_item_name:
			complete_objective(current_objective)
