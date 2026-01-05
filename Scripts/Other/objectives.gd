extends VBoxContainer

const OBJECTIVES_FILE_PATH = "res://Assets/Objectives.json"

var objectives = {}
var current_objective = "movement"

func _ready() -> void:
	parse_objectives()
	update_ui()


func parse_objectives() -> void:
	var file = FileAccess.open(OBJECTIVES_FILE_PATH, FileAccess.READ)
	objectives = JSON.parse_string(file.get_as_text())
	print(objectives)
	file.close()


func set_objective(objective : String) -> void:
	if objective in objectives:
		current_objective = objective
		update_ui()


func update_ui() -> void:
	var description : String = objectives[current_objective]["description"]
	var regex = RegEx.new()
	regex.compile(r"(?<=CONTROL\()[^)]+(?=\))")
	for action in regex.search_all(description):
		print(action.get_string())
		if InputMap.has_action(action.get_string()) and InputMap.action_get_events(action.get_string()).size() > 0:
			var event = InputMap.action_get_events(action.get_string())[0]
			var keybind = event.as_text().replace("(Physical)", "").lstrip(" ").rstrip(" ")
			description = description.replace("CONTROL(" + action.get_string() + ")", keybind)
	
	$Description.text = description


func complete_objective(objective : String) -> void:
	if current_objective == objective:
		if objectives[current_objective]["next_objective"] != "":
			set_objective(objectives[current_objective]["next_objective"])
		else:
			hide()
