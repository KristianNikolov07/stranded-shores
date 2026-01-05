extends PanelContainer

signal closed

const control_option_scene = preload("res://Scenes/Menu/control_option.tscn")
const blacklist = ["esc", "Debug", "Click"]

var config = ConfigFile.new()

func _ready() -> void:
	hide()
	load_controls()


func _on_back_pressed() -> void:
	save_controls()
	hide()
	closed.emit()


func save_controls() -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	for action in InputMap.get_actions():
		if !action.begins_with("ui_") and action not in blacklist and InputMap.action_get_events(action).size() > 0:
			config.set_value("Controls", action, InputMap.action_get_events(action)[0])
	config.save(Global.SETTINGS_FILE_PATH)

func load_controls() -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	for action in config.get_section_keys("Controls"):
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, config.get_value("Controls", action))


func list_controls() -> void:
	for child in %Controls.get_children():
		child.queue_free()
	for action : StringName in InputMap.get_actions():
		if InputMap.action_get_events(action).is_empty() == false and action.begins_with("ui_") == false and action not in blacklist:
			var control_option = control_option_scene.instantiate()
			control_option.action = action
			control_option.key = InputMap.action_get_events(action)[0].as_text()
			%Controls.add_child(control_option)
