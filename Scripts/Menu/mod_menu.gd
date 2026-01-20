extends PanelContainer

signal closed

const MOD_PANEL_SCENE = preload("res://Scenes/Menu/mod_panel.tscn")

var zip = ZIPReader.new()

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
			var mod_panel = MOD_PANEL_SCENE.instantiate()
			mod_panel.mod_path = Global.MODS_FOLDER + "/" + mod
			%ModList.add_child(mod_panel)


func _on_back_pressed() -> void:
	var restart_required = false
	var reload_required = false
	for mod in %ModList.get_children():
		if mod.enabled_originally == false and mod.enabled == true:
			reload_required = true
		elif mod.enabled_originally == true and mod.enabled == false:
			restart_required = true
	
	if restart_required:
		OS.alert(tr("RESTART_WARNING_MESSAGE"), tr("RESTART_WARNING_TITLE"))
	if reload_required:
		get_tree().change_scene_to_file("res://Scenes/mod_loader.tscn")
	hide()
	closed.emit()


func _on_add_mod_pressed() -> void:
	$FileDialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	var file_name : String = path.split("/")[-1]
	if file_name.ends_with(".zip"):
		zip.open(path)
		if "manifest.json" in zip.get_files() and "mod.pck" in zip.get_files():
			var mod_folder = file_name.replace(".zip", "")
			
			# Folder Setup
			if DirAccess.dir_exists_absolute(Global.MODS_FOLDER) == false:
				DirAccess.make_dir_absolute(Global.MODS_FOLDER)
			if DirAccess.dir_exists_absolute(Global.MODS_FOLDER + "/" + mod_folder) == false:
				DirAccess.make_dir_absolute(Global.MODS_FOLDER + "/" + mod_folder)
				
				# Copy files
				var mod_buffer = zip.read_file("mod.pck")
				var manifest_buffer = zip.read_file(Global.MODS_MANIFEST_FILE_NAME)
				print(manifest_buffer)
				
				var mod_file = FileAccess.open(Global.MODS_FOLDER + "/" + mod_folder + "/mod.pck", FileAccess.WRITE)
				mod_file.store_buffer(mod_buffer)
				mod_file.close()
				
				var manifest_file = FileAccess.open(Global.MODS_FOLDER + "/" + mod_folder + "/" + Global.MODS_MANIFEST_FILE_NAME, FileAccess.WRITE)
				manifest_file.store_buffer(manifest_buffer)
				manifest_file.close()
				
				# Enable Check File Setup
				var enabled_check_file = FileAccess.open(Global.MODS_FOLDER + "/" + mod_folder + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME, FileAccess.WRITE)
				enabled_check_file.store_var(false)
				enabled_check_file.close()
				
				list_mods()
				
		else:
			OS.alert("Invalid Mod", "Invalid Mod")
