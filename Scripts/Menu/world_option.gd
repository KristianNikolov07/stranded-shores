extends Control

const POPUP_SCENE = preload("res://Scenes/Menu/popup.tscn")

var world_info : WorldInfo
var is_world_from_a_future_version = false
var delete_pressed = false

func _ready() -> void:
	%WorldName.text = world_info.world_name
	%Delete/ProgressBar.max_value = %Delete/DeleteTimer.wait_time
	display_playtime()
	check_checksum()
	check_if_modded()
	check_version()
	if world_info.world_seed == null:
		%CopySeed.hide()


func _process(_delta: float) -> void:
	if %Delete.is_pressed():
		%Delete/ProgressBar.value = %Delete/ProgressBar.max_value - %Delete/DeleteTimer.time_left
	else:
		%Delete/ProgressBar.value = 0


func _on_play_pressed() -> void:
	if not world_info.is_checksum_valid:
		show_checksum_warning()
	elif is_world_from_a_future_version:
		show_version_warning()
	elif world_info.is_modded:
		show_modded_warning()
	else:
		start_world()


func show_checksum_warning() -> void:
	var popup = POPUP_SCENE.instantiate()
	popup.title = "WARNING"
	popup.description = "CHECKSUM_ERROR"
	popup.option1 = "I_KNOW_WHAT_I_AM_DOING"
	popup.option2 = "CANCEL"
	popup.option1_pressed.connect(start_world)
	get_tree().current_scene.add_child(popup)


func show_version_warning() -> void:
	var popup = POPUP_SCENE.instantiate()
	popup.title = "WARNING"
	popup.description = tr("VERSION_ERROR") + "\n[url=https://github.com/KristianNikolov07/stranded-shores/releases/tag/v." + world_info.world_version + "]Download v" + world_info.world_version + "[/url]"
	popup.option1 = "I_KNOW_WHAT_I_AM_DOING"
	popup.option2 = "CANCEL"
	popup.option1_pressed.connect(start_world)
	get_tree().current_scene.add_child(popup)


func show_modded_warning() -> void:
	var popup = POPUP_SCENE.instantiate()
	popup.title = "WARNING"
	popup.description = "MODDED_WORLD_WARNING"
	popup.option1 = "I_KNOW_WHAT_I_AM_DOING"
	popup.option2 = "CANCEL"
	popup.option1_pressed.connect(start_world)
	get_tree().current_scene.add_child(popup)


func start_world() -> void:
	SaveProgress.save_name = world_info.world_name
	get_tree().change_scene_to_file("res://Scenes/Menu/loading_screen.tscn")


func _on_delete_button_up() -> void:
	if has_node("%Delete"):
		%Delete/DeleteTimer.stop()


func _on_delete_button_down() -> void:
	if %Delete/DeleteTimer.is_stopped():
		%Delete/DeleteTimer.start()


func _on_delete_timer_timeout() -> void:
	SaveProgress.delete(world_info.world_name)
	queue_free()


func display_playtime() -> void:
	if world_info.playtime <= 0:
		%Playtime.hide()
		return

	%Playtime.show()

	var s = int(world_info.playtime)
	@warning_ignore("integer_division")
	var m = s / 60
	s = s % 60
	@warning_ignore("integer_division")
	var h = m / 60
	m = m % 60
	@warning_ignore("integer_division")
	var d = h / 24
	h = h % 24

	if d > 0:
		%Playtime.text = (str(d) + " d") + ("" if h == 0 else " " + str(h) + " h")
	elif h > 0:
		%Playtime.text = (str(h) + " h") + ("" if m == 0 else " " + str(m) + " min")
	elif m > 0:
		%Playtime.text = (str(m) + " min") + ("" if s == 0 else " " + str(s) + " sec")
	else:
		%Playtime.text = str(s) + " sec"


func check_checksum() -> void:
	if not world_info.is_checksum_valid:
		%WorldName.add_theme_color_override("font_color", Color.RED)


func check_version() -> void:
	var current_version : String = ProjectSettings.get_setting("application/config/version")
	if world_info.version == "":
		return
	var version_arr = world_info.version.split(".")
	var current_version_arr = current_version.split(".")
	for i in range(mini(version_arr.size(), current_version_arr.size())):
		var v = int(version_arr[i])
		var cv = int(current_version_arr[i])
		if v > cv:
			is_world_from_a_future_version = true
			%WorldName.add_theme_color_override("font_color", Color.RED)
			return
		elif v < cv:
			return


func check_if_modded() -> void:
	if world_info.is_modded:
		%WorldName.add_theme_color_override("font_color", Color.ORANGE)


func _on_copy_seed_pressed() -> void:
	DisplayServer.clipboard_set(str(world_info.world_seed))
