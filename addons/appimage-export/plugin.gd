@tool
extends EditorPlugin
var appimage_export_plugin = AppimageExportPlugin.new()

func _enable_plugin() -> void:
	add_export_plugin(appimage_export_plugin)
