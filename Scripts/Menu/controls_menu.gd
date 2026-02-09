extends PanelContainer

signal closed

const CONTROL_OPTION_SCENE = preload("res://Scenes/Menu/control_option.tscn")
const BLACKLIST = ["esc", "Debug", "Click", "ToggleFullscreen"]

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


func open() -> void:
	list_controls()
	show()
	if Global.is_using_controller:
		$VBoxContainer/MarginContainer/HBoxContainer/Back.grab_focus()
		$VBoxContainer/MarginContainer2/HBoxContainer/OptionButton.select(1)


func save_controls() -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	for action in InputMap.get_actions():
		if !action.begins_with("ui_") and action not in BLACKLIST and InputMap.action_get_events(action).size() > 0:
			config.set_value("Controls", action, InputMap.action_get_events(action))
	config.save(Global.SETTINGS_FILE_PATH)


func load_controls() -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	if config.has_section("Controls"):
		for action in config.get_section_keys("Controls"):
			if InputMap.has_action(action):
				if config.get_value("Controls", action) is Array:
					set_key(action, config.get_value("Controls", action)[0])
					if config.get_value("Controls", action).size() > 1:
						set_key(action, config.get_value("Controls", action)[1], true)


func set_key(action : String, key : InputEvent, is_controller = false) -> void:
	var previous_keys = InputMap.action_get_events(action)
	InputMap.action_erase_events(action)
	if is_controller:
		InputMap.action_add_event(action, previous_keys[0])
		InputMap.action_add_event(action, key)
	else:
		InputMap.action_add_event(action, key)
		if previous_keys.size() > 1:
			InputMap.action_add_event(action, previous_keys[1])


func list_controls() -> void:
	for child in %Controls.get_children():
		child.queue_free()
	for action : StringName in InputMap.get_actions():
		if InputMap.action_get_events(action).is_empty() == false and action.begins_with("ui_") == false and action not in BLACKLIST:
			var control_option = CONTROL_OPTION_SCENE.instantiate()
			control_option.action = action
			if Global.is_using_controller == false:
				control_option.key = InputMap.action_get_events(action)[0]
				%Controls.add_child(control_option)
			elif InputMap.action_get_events(action).size() > 1:
				control_option.is_controller = true
				control_option.key = InputMap.action_get_events(action)[1]
				%Controls.add_child(control_option)


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		Global.is_using_controller = false
	else:
		Global.is_using_controller = true
	list_controls()
	
