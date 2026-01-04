extends Control

func _ready() -> void:
	hide()


func _on_world_name_text_changed(new_text: String) -> void:
	if new_text.replace(" ", "") != "" and SaveProgress.has_save_with_name(new_text.replace(" ", "")) == false:
		$CenterContainer/VBoxContainer/CreateNewWorld.disabled = false
	else:
		$CenterContainer/VBoxContainer/CreateNewWorld.disabled = true


func _on_create_new_world_pressed() -> void:
	SaveProgress.save_name = $CenterContainer/VBoxContainer/WorldName.text
	get_tree().change_scene_to_file("res://Scenes/Worlds/main.tscn")


func _on_back_pressed() -> void:
	hide()
