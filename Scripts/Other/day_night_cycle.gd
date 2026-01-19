extends DirectionalLight2D

@export var night_energy = 0.8
@export var day_time = 420
@export var night_time = 180

var is_night = false

func _ready() -> void:
	if $Timer.is_stopped():
		$Timer.start(day_time)


func set_to_day(is_immediate = false, time_left = day_time) -> void:
	if is_immediate == false:
		$AnimationPlayer.play_backwards("day-night-transition")
	else:
		energy = 0
		is_night = false
	$Timer.stop()
	$Timer.start(time_left)


func set_to_night(is_immediate = false, time_left = night_time) -> void:
	if is_immediate == false:
		$AnimationPlayer.play("day-night-transition")
	else:
		energy = night_energy
		is_night = true
	$Timer.stop()
	$Timer.start(time_left)


func _on_timer_timeout() -> void:
	if is_night:
		set_to_day()
	else:
		set_to_night()
