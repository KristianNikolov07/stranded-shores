extends Structure

@export var min_grow_secs = 60
@export var max_grow_secs = 120

func _ready() -> void:
	$GrowTimer.start(randf_range(min_grow_secs, max_grow_secs))


func _on_grow_timer_timeout() -> void:
	var tree = load("res://Scenes/Structures/tree.tscn").instantiate()
	tree.global_position = global_position
	get_tree().current_scene.add_child(tree)
	queue_free()
