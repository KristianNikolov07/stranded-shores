extends Area2D

@export var objective_name : String

func _on_body_entered(body: Node2D) -> void:
	print("aaaaa")
	body.objectives.complete_objective(objective_name)
