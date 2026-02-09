extends Control

func _ready() -> void:
	SaveProgress.save_name = "" # So it doesn't try to save the game while in the main menu
	SaveProgress.get_node("PlaytimeCounter").stop()
	
	$Version.text = ProjectSettings.get_setting("application/config/version")
	
	# Web
	if OS.get_name() == "Web":
		$MainButtons/Quit.hide()
	
	# Focus
	if Global.is_using_controller:
		$MainButtons/Play.grab_focus()


func _on_play_pressed() -> void:
	$MainButtons.hide()
	$WorldSelect.open()


func _on_settings_pressed() -> void:
	$MainButtons.hide()
	$SettingsMenu.open()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_menu_closed() -> void:
	$MainButtons.show()
	if Global.is_using_controller:
		$MainButtons/Play.grab_focus()


func _on_world_select_closed() -> void:
	$MainButtons.show()
	if Global.is_using_controller:
		$MainButtons/Play.grab_focus()


func _on_mod_menu_closed() -> void:
	$SettingsMenu.open()


func _on_credits_pressed() -> void:
	$Credits.open()
	$MainButtons.hide()


func _on_credits_closed() -> void:
	$MainButtons.show()
	if Global.is_using_controller:
		$MainButtons/Play.grab_focus()
