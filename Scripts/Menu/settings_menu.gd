extends Control

signal closed

var config = ConfigFile.new()

func _ready() -> void:
	hide()
	
	# Get Settings from file
	config.load(Global.SETTINGS_FILE_PATH)
	var lang = config.get_value("Settings", "Language", 0)
	var volume = config.get_value("Settings", "Volume", 100)
	set_language(lang)
	%Language.selected = lang
	set_volume(volume)
	%VolumeSlider.value = volume
	
	# Disable Mod Button if not in the menu
	if get_tree().current_scene.name != "MainMenu":
		%Mods.disabled = true
	
	# Web
	if OS.get_name() == "Web":
		%Mods.disabled = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_back_pressed()
			accept_event()


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func _on_language_selected(index: int) -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	config.set_value("Settings", "Language", index)
	config.save(Global.SETTINGS_FILE_PATH)
	set_language(index)


func open() -> void:
	show()
	$Back.grab_focus()


func set_language(lang : int):
	if lang == 0:
		TranslationServer.set_locale("en")
	elif lang == 1:
		TranslationServer.set_locale("bg")


func _on_volume_changed(value : float) -> void:
	config.load(Global.SETTINGS_FILE_PATH)
	config.set_value("Settings", "Volume", value)
	config.save(Global.SETTINGS_FILE_PATH)
	set_volume(value)


func set_volume(volume : float):
	AudioServer.set_bus_volume_linear(0, volume)


func _on_mods_pressed() -> void:
	hide()
	get_node("../ModMenu").show()


func _on_controls_pressed() -> void:
	%ControlsMenu.show()
	%ControlsMenu.list_controls()


func _on_controls_menu_closed() -> void:
	show()
	$Back.grab_focus()
