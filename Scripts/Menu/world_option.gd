extends Control

var world_name = "Test"
var delete_pressed = false

func _ready() -> void:
	$MarginContainer/HBoxContainer/Label.text = world_name
	$MarginContainer/HBoxContainer/Buttons/Delete/ProgressBar.max_value = $MarginContainer/HBoxContainer/Buttons/Delete/DeleteTimer.wait_time


func _process(_delta: float) -> void:
	if $MarginContainer/HBoxContainer/Buttons/Delete.is_pressed():
		$MarginContainer/HBoxContainer/Buttons/Delete/ProgressBar.value = $MarginContainer/HBoxContainer/Buttons/Delete/ProgressBar.max_value - $MarginContainer/HBoxContainer/Buttons/Delete/DeleteTimer.time_left
	else:
		$MarginContainer/HBoxContainer/Buttons/Delete/ProgressBar.value = 0


func _on_play_pressed() -> void:
	SaveProgress.save_name = world_name
	get_tree().change_scene_to_file("res://Scenes/Menu/loading_screen.tscn")


func _on_delete_button_up() -> void:
	$MarginContainer/HBoxContainer/Buttons/Delete/DeleteTimer.stop()


func _on_delete_button_down() -> void:
	if $MarginContainer/HBoxContainer/Buttons/Delete/DeleteTimer.is_stopped():
		$MarginContainer/HBoxContainer/Buttons/Delete/DeleteTimer.start()


func _on_delete_timer_timeout() -> void:
	SaveProgress.delete(world_name)
	queue_free()
