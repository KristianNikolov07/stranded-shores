extends Control

@onready var player : Player = get_node("../../")

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_resume_pressed()
		elif player.can_move:
			get_tree().paused = true
			show()
			$Buttons/Resume.grab_focus()


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	$Buttons.show()
	$SettingsMenu.hide()


func _on_settings_pressed() -> void:
	$Buttons.hide()
	$SettingsMenu.open()


func _on_save_and_quit_pressed() -> void:
	SaveProgress.save()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_settings_menu_closed() -> void:
	$Buttons.show()
	$Buttons/Resume.grab_focus()
