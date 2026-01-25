extends DirectionalLight2D

## The script responcible for the day/night cycle

## The light enery during night time 
@export var night_energy = 0.8
## The amount of time the day lasts for
@export var day_time = 420
## The amount of time the night lasts for
@export var night_time = 180

## Whether or not it is night time
var is_night = false

func _ready() -> void:
	if $Timer.is_stopped():
		$Timer.start(day_time)


## Sets the time to day
func set_to_day(is_immediate = false, time_left = day_time) -> void:
	if is_immediate == false:
		$AnimationPlayer.play_backwards("day-night-transition")
	else:
		energy = 0
	is_night = false
	$Timer.stop()
	$Timer.start(time_left)


## Sets the time to night
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
