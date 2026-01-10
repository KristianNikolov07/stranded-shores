extends Area2D

@export var objective_name : String

func _on_body_entered(_body: Node2D) -> void:
	Global.get_player().objectives.complete_objective(objective_name)
