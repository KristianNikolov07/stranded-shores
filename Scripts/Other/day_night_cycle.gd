extends DirectionalLight2D

var is_night = false

func _on_timer_timeout() -> void:
	if is_night:
		$AnimationPlayer.play_backwards("day-night-transition")
	else:
		$AnimationPlayer.play("day-night-transition")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_night = !is_night
