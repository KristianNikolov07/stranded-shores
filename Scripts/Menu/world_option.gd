extends Control

var world_name = "Test"
var delete_pressed = false

func _ready() -> void:
	%WorldName.text = world_name
	%Delete/ProgressBar.max_value = %Delete/DeleteTimer.wait_time
	set_playtime()


func _process(_delta: float) -> void:
	if %Delete.is_pressed():
		%Delete/ProgressBar.value = %Delete/ProgressBar.max_value - %Delete/DeleteTimer.time_left
	else:
		%Delete/ProgressBar.value = 0


func _on_play_pressed() -> void:
	SaveProgress.save_name = world_name
	get_tree().change_scene_to_file("res://Scenes/Menu/loading_screen.tscn")


func _on_delete_button_up() -> void:
	if has_node("%Delete"):
		%Delete/DeleteTimer.stop()


func _on_delete_button_down() -> void:
	if %Delete/DeleteTimer.is_stopped():
		%Delete/DeleteTimer.start()


func _on_delete_timer_timeout() -> void:
	SaveProgress.delete(world_name)
	queue_free()


func set_playtime() -> void:
	var playtime: int = int(SaveProgress.get_playtime(world_name))

	if playtime <= 0:
		%Playtime.hide()
		return

	%Playtime.show()

	var s = playtime
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
