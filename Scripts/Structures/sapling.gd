extends Structure

const TREE_SCENE = preload("res://Scenes/Structures/tree.tscn")

@export var min_grow_secs = 60
@export var max_grow_secs = 120

func _ready() -> void:
	$GrowTimer.wait_time = randf_range(min_grow_secs, max_grow_secs)
	$GrowTimer.start()


func _on_grow_timer_timeout() -> void:
	var tree = TREE_SCENE.instantiate()
	tree.global_position = global_position
	get_tree().current_scene.add_child(tree)
	queue_free()
