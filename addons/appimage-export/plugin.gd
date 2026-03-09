@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_export_plugin(AppimageExportPlugin.new())
