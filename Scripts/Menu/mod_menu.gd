extends PanelContainer

signal closed

const mod_panel_scene = preload("res://Scenes/Menu/mod_panel.tscn")

func _ready() -> void:
	list_mods()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_back_pressed()
			accept_event()


func list_mods() -> void:
	for child in %ModList.get_children():
		child.queue_free()
	if DirAccess.dir_exists_absolute(Global.MODS_FOLDER):
		for mod : String in DirAccess.get_directories_at(Global.MODS_FOLDER):
			var mod_panel = mod_panel_scene.instantiate()
			mod_panel.mod_path = Global.MODS_FOLDER + "/" + mod
			%ModList.add_child(mod_panel)


func _on_back_pressed() -> void:
	OS.alert(tr("RESTART_WARNING_MESSAGE"), tr("RESTART_WARNING_TITLE"))
	hide()
	closed.emit()


func _on_add_mod_pressed() -> void:
	$FileDialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	var file_name : String = path.split("/")[-1]
	if file_name.ends_with(".pck"):
		var mod_name = file_name.replace(".pck", "")
		if DirAccess.dir_exists_absolute(Global.MODS_FOLDER) == false:
			DirAccess.make_dir_absolute(Global.MODS_FOLDER)
		if DirAccess.dir_exists_absolute(Global.MODS_FOLDER + "/" + mod_name) == false:
			DirAccess.make_dir_absolute(Global.MODS_FOLDER + "/" + mod_name)
			DirAccess.copy_absolute(path, Global.MODS_FOLDER + "/" + mod_name + "/mod.pck")
			var enabled_check_file = FileAccess.open(Global.MODS_FOLDER + "/" + mod_name + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME, FileAccess.WRITE)
			enabled_check_file.store_var(false)
			enabled_check_file.close()
			
			list_mods()
