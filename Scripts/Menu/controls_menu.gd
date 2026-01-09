extends PanelContainer

signal closed

const CONTROL_OPTION_SCENE = preload("res://Scenes/Menu/control_option.tscn")
const BLACKLIST = ["esc", "Debug", "Click"]

var config = ConfigFile.new()

func _ready() -> void:
	hide()
	load_controls()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_back_pressed()
			accept_event()


func _on_back_pressed() -> void:
	save_controls()
	hide()
	closed.emit()


func save_controls() -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	for action in InputMap.get_actions():
		if !action.begins_with("ui_") and action not in BLACKLIST and InputMap.action_get_events(action).size() > 0:
			config.set_value("Controls", action, InputMap.action_get_events(action)[0])
	config.save(Global.SETTINGS_FILE_PATH)

func load_controls() -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	if config.has_section("Controls"):
		for action in config.get_section_keys("Controls"):
			if InputMap.has_action(action):
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action, config.get_value("Controls", action))


func list_controls() -> void:
	for child in %Controls.get_children():
		child.queue_free()
	for action : StringName in InputMap.get_actions():
		if InputMap.action_get_events(action).is_empty() == false and action.begins_with("ui_") == false and action not in BLACKLIST:
			var control_option = CONTROL_OPTION_SCENE.instantiate()
			control_option.action = action
			control_option.key = InputMap.action_get_events(action)[0].as_text()
			%Controls.add_child(control_option)
