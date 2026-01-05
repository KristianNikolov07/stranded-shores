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
	$Description.text = objectives[current_objective]["description"]


func complete_objective(objective : String) -> void:
	if current_objective == objective:
		if objectives[current_objective]["next_objective"] != "":
			set_objective(objectives[current_objective]["next_objective"])
		else:
			hide()
