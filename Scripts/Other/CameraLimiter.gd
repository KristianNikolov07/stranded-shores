extends Camera2D

func _ready() -> void:
	var world_bounds = get_tree().get_first_node_in_group("WorldBounds")
	
	limit_left = world_bounds.get_node("Left").global_position.x
	limit_top = world_bounds.get_node("Top").global_position.y
	limit_right = world_bounds.get_node("Right").global_position.x
	limit_bottom = world_bounds.get_node("Bottom").global_position.y
