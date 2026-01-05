extends Control

func _ready() -> void:
	SaveProgress.save_name = "" # So it doesn't try to save the game while in the main menu
	
	$Version.text = ProjectSettings.get_setting("application/config/version")
	
	# Web
	if OS.get_name() == "Web":
		$MainButtons/Quit.hide()

func _on_play_pressed() -> void:
	$MainButtons.hide()
	$WorldSelect.show()


func _on_settings_pressed() -> void:
	$MainButtons.hide()
	$SettingsMenu.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_menu_closed() -> void:
	$MainButtons.show()


func _on_world_select_closed() -> void:
	$MainButtons.show()


func _on_mod_menu_closed() -> void:
	$SettingsMenu.show()
