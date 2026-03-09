class_name AppimageExportPlugin
extends EditorExportPlugin

var executable_path = ""

func _get_export_options(platform: EditorExportPlatform) -> Array[Dictionary]:
	if platform.get_os_name() == "Linux":
		return[
			{
				"option":{
					"name":"appimage/generate_an_appimage",
					"type": 1,
				},
				"default_value": false,
			},
			{
				"option":{
					"name":"appimage/app_name",
					"type": 4,
				},
				"default_value": ProjectSettings.get_setting("application/config/name")
			},
			{
				"option":{
					"name":"appimage/icon",
					"type": 4,
					"hint": PROPERTY_HINT_GLOBAL_FILE,
				},
				"default_value": ProjectSettings.get_setting("application/config/icon")
			}
		]
	return []


func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	executable_path = path


func _export_end() -> void:
	if get_export_platform().get_os_name() != "Linux":
		return
	if get_option("appimage/generate_an_appimage") == false:
		return
	if executable_path.ends_with(".pck"):
		return
	
	print("Exporting an AppImage...")
	var appdir_path = setup_appdir()
	generate_desktop_file(appdir_path, get_option("appimage/app_name"))
	copy_executable(appdir_path)
	if get_option("appimage/icon") != null:
		copy_icon(appdir_path, get_option("appimage/icon"))
	if get_option("binary_format/embed_pck") == false:
		copy_pck(appdir_path)
	generate_apprun(appdir_path)
	package_appimage(appdir_path)
	remove_appdir(appdir_path)
	executable_path = ""


## Returns the path to the appdir
func setup_appdir() -> String:
	var path = executable_path.get_base_dir().path_join(executable_path.get_file()) + ".AppDir"
	DirAccess.make_dir_absolute(path)
	DirAccess.make_dir_recursive_absolute(path.path_join("usr/bin"))
	return path


func generate_desktop_file(appdir_path: String, app_name : String) -> void:
	var file = FileAccess.open(appdir_path.path_join(executable_path.get_file().get_basename() + ".desktop"), FileAccess.WRITE)
	file.store_string("[Desktop Entry]
Name=" + app_name + "
Icon=icon
Exec=" + executable_path.get_file() + "
Type=Application
Categories=Game
")
	file.close()


func copy_executable(appdir_path : String) -> void:
	DirAccess.copy_absolute(executable_path, appdir_path.path_join("usr/bin").path_join(executable_path.get_file()))
	OS.execute("chmod", ["+x", appdir_path.path_join("usr/bin").path_join(executable_path.get_file())])


func copy_icon(appdir_path : String, icon_path : String) -> void:
	print("Copying the icon...")
	DirAccess.copy_absolute(icon_path, appdir_path.path_join("icon.png"))


func copy_pck(appdir_path : String) -> void:
	var pck_path = executable_path.get_basename() + ".pck"
	DirAccess.copy_absolute(pck_path, appdir_path.path_join("usr/bin").path_join(executable_path.get_file().get_basename() + ".pck"))


func generate_apprun(appdir_path : String) -> void:
	print("Generating AppRun...")
	var file = FileAccess.open(appdir_path.path_join("AppRun"), FileAccess.WRITE)
	file.store_string('#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
exec "${HERE}/usr/bin/' + executable_path.get_file() + '" "$@"
')
	file.close()
	OS.execute("chmod", ["+x", appdir_path.path_join("AppRun")])


func package_appimage(appdir_path : String) -> void:
	print('Packaging...')
	var output = []
	OS.execute("appimagetool", [appdir_path, appdir_path.get_base_dir().path_join(executable_path.get_file().get_basename()) + ".AppImage"], output, true, true)
	print(output)


func remove_appdir(appdir_path : String) -> void:
	OS.execute("rm", ["-rf", appdir_path])
