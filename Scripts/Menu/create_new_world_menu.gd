extends Control

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_back_pressed()
			accept_event()

func _on_world_name_text_changed(new_text: String) -> void:
	if new_text.replace(" ", "") != "" and SaveProgress.has_save_with_name(new_text.replace(" ", "")) == false:
		%CreateNewWorld.disabled = false
	else:
		%CreateNewWorld.disabled = true


func _on_create_new_world_pressed() -> void:
	SaveProgress.save_name = %WorldName.text
	if %WorldSeed.text == "":
		SaveProgress.world_seed = randi()
	else:
		if int(%WorldName.text) == 0:
			SaveProgress.world_seed = hash(%WorldSeed.text)
		else:
			SaveProgress.world_seed = int(%WorldSeed.text)
	get_tree().change_scene_to_file("res://Scenes/Menu/loading_screen.tscn")


func _on_back_pressed() -> void:
	hide()
