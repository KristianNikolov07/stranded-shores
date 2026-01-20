extends Node

var playtime : float = 0
var is_counting = false


func _process(delta: float) -> void:
	if is_counting:
		playtime += delta


func start(start_from = 0) -> void:
	playtime = start_from
	is_counting = true


func stop() -> void:
	is_counting = false
