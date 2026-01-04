extends Control

signal closed

const SETTINGS_FILE_PATH = "user://settings.ini"

var config = ConfigFile.new()

func _ready() -> void:
	hide()
	
	# Get Settings from file
	config.load(SETTINGS_FILE_PATH)
	var lang = config.get_value("Settings", "Language", 0)
	var volume = config.get_value("Settings", "Volume", 100)
	set_language(lang)
	$CenterContainer/Settings/Language/Language.selected = lang
	set_volume(volume)
	$CenterContainer/Settings/Volume/HSlider.value = volume
	
	# Disable Mod Button if not in the menu
	if get_tree().current_scene.name != "MainMenu":
		$CenterContainer/Settings/Mods.disabled = true


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func _on_language_selected(index: int) -> void:
	config.load(SETTINGS_FILE_PATH)
	config.set_value("Settings", "Language", index)
	config.save(SETTINGS_FILE_PATH)
	set_language(index)


func set_language(lang : int):
	if lang == 0:
		TranslationServer.set_locale("en")
	elif lang == 1:
		TranslationServer.set_locale("bg")


func _on_volume_changed(value : float) -> void:
	config.load(SETTINGS_FILE_PATH)
	config.set_value("Settings", "Volume", value)
	config.save(SETTINGS_FILE_PATH)
	set_volume(value)


func set_volume(volume : float):
	AudioServer.set_bus_volume_linear(0, volume)


func _on_mods_pressed() -> void:
	hide()
	get_node("../ModMenu").show()
