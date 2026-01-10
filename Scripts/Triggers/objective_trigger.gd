extends Area2D

@export var objective_name : String

func _on_body_entered(_body: Node2D) -> void:
	get_tree().get_first_node_in_group("Objective").complete_objective(objective_name)
