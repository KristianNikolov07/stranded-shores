extends DirectionalLight2D

@export var night_energy = 0.8

var is_night = false

func _on_timer_timeout() -> void:
	if is_night:
		set_to_day()
	else:
		set_to_night()


func set_to_day(is_immediate = false) -> void:
	if is_immediate == false:
		$AnimationPlayer.play_backwards("day-night-transition")
	energy = 0
	is_night = false


func set_to_night(is_immediate = false) -> void:
	if is_immediate == false:
		$AnimationPlayer.play("day-night-transition")
	energy = night_energy
	is_night = true
