extends Area2D

func clear_area() -> void:
	for body in get_overlapping_bodies():
		body.queue_free()
