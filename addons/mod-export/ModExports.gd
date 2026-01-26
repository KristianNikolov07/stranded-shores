class_name ModExports
extends EditorExportPlugin

var export_pck_path : String = ""

func _get_name() -> String:
	return "ModExports"

func _get_export_options(platform: EditorExportPlatform) -> Array[Dictionary]:
	return [
		{
			"option": {"name": "Mod Name", "type": Variant.Type.TYPE_STRING},
			"default_value": "My Mod"
		},
		{
			"option": {"name": "Mod Author", "type": Variant.Type.TYPE_STRING},
			"default_value": "Me"
		}
	]

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if get_export_preset().get_preset_name() == "Mod" and path.ends_with(".pck"):
		export_pck_path = path
		generate_manifest_file(path.get_base_dir())

func _export_end() -> void:
	if get_export_preset().get_preset_name() == "Mod":
		if export_pck_path != "" and export_pck_path.ends_with(".pck"):
			var mod_name := str(get_option("Mod Name"))
			var zip_file_name := mod_name.to_lower().replace(" ", "_") + ".zip"
			var zip_path := export_pck_path.get_base_dir().path_join(zip_file_name)

			var packer := ZIPPacker.new()
			var err := packer.open(zip_path)
			if err != OK:
				push_error("ZIPPacker.open failed: %s" % err)
				return

			# mod.pck
			packer.start_file("mod.pck")
			var mod_pck := FileAccess.open(export_pck_path, FileAccess.READ)
			if mod_pck == null:
				push_error("Failed to open exported pck: " + export_pck_path)
				packer.close()
				return
			packer.write_file(mod_pck.get_buffer(mod_pck.get_length()))
			mod_pck.close()
			packer.close_file()

			# manifest.json
			var manifest_path := export_pck_path.get_base_dir().path_join("manifest.json")
			packer.start_file("manifest.json")
			var manifest_file := FileAccess.open(manifest_path, FileAccess.READ)
			if manifest_file == null:
				push_error("Failed to open manifest: " + manifest_path)
				packer.close()
				return
			packer.write_file(manifest_file.get_as_text().to_utf8_buffer())
			manifest_file.close()
			packer.close_file()

			packer.close()

func generate_manifest_file(dir_path: String) -> void:
	var manifest = {
		"name": str(get_option("Mod Name")),
		"author": str(get_option("Mod Author"))
	}
	var file = FileAccess.open(dir_path.path_join("manifest.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify(manifest, "\t"))
	file.close()
