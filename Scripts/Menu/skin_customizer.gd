extends PanelContainer

signal close

var unsaved_changes = false

func _ready() -> void:
	hide()


func open() -> void:
	show()
	set_to_default_colors()
	load_from_file()


func set_to_default_colors() -> void:
	%HairColor.color = %PlayerSprite.DEFAULT_HAIR_COLOR
	%PlayerSprite.set_hair_color(%PlayerSprite.DEFAULT_HAIR_COLOR)
	%SkinColor.color = %PlayerSprite.DEFAULT_SKIN_COLOR
	%PlayerSprite.set_skin_color(%PlayerSprite.DEFAULT_SKIN_COLOR)
	%ShirtColor.color = %PlayerSprite.DEFAULT_SHIRT_COLOR
	%PlayerSprite.set_shirt_color(%PlayerSprite.DEFAULT_SHIRT_COLOR)
	set_unsaved_changes(true)

func load_from_file() -> void:
	var config = ConfigFile.new()
	var err = config.load(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	if err != OK:
		return
	var hair = config.get_value("colors", "hair_color", %PlayerSprite.DEFAULT_HAIR_COLOR)
	var skin = config.get_value("colors", "skin_color", %PlayerSprite.DEFAULT_SKIN_COLOR)
	var shirt = config.get_value("colors", "shirt_color", %PlayerSprite.DEFAULT_SHIRT_COLOR)
	%HairColor.color = hair
	%PlayerSprite.set_hair_color(hair)
	%SkinColor.color = skin
	%PlayerSprite.set_skin_color(skin)
	%ShirtColor.color = shirt
	%PlayerSprite.set_shirt_color(shirt)
	set_unsaved_changes(false)


func set_unsaved_changes(_unsaved_changes : bool) -> void:
	unsaved_changes = _unsaved_changes
	%Save.disabled = !unsaved_changes


func _on_save_pressed() -> void:
	var config = ConfigFile.new()
	config.load(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	config.set_value("colors", "hair_color", %HairColor.color)
	config.set_value("colors", "skin_color", %SkinColor.color)
	config.set_value("colors", "shirt_color", %ShirtColor.color)
	config.save(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	set_unsaved_changes(false)


func _on_reset_to_default_pressed() -> void:
	set_to_default_colors()


func _on_close_pressed() -> void:
	hide()
	close.emit()


func _on_hair_color_color_changed(color: Color) -> void:
	%PlayerSprite.set_hair_color(color)
	set_unsaved_changes(true)


func _on_skin_color_color_changed(color: Color) -> void:
	%PlayerSprite.set_skin_color(color)
	set_unsaved_changes(true)


func _on_shirt_color_color_changed(color: Color) -> void:
	%PlayerSprite.set_shirt_color(color)
	set_unsaved_changes(true)
