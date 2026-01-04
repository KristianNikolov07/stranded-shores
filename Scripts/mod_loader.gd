extends Node

func _ready() -> void:
	for mod in DirAccess.get_directories_at(Global.MODS_FOLDER):
		var mod_path = Global.MODS_FOLDER + "/" + mod
		var enabled_check_file = FileAccess.open(mod_path + "/" + Global.MODS_ENABLE_CHECK_FILE_NAME, FileAccess.READ)
		if enabled_check_file.get_var() == true:
			load_mod(mod_path)
		enabled_check_file.close()
	
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/main_menu.tscn")


func load_mod(mod_path : String):
	var success = ProjectSettings.load_resource_pack(mod_path + "/mod.pck")
	
	if success:
		print("The Mod at " + mod_path + " Loaded Successfully!")
	else:
		print("Failed to load: " + mod_path)
