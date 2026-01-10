extends Node2D

signal hit

const ARROW_SCENE = preload("res://Scenes/Objects/arrow.tscn")

func use() -> void:
	var player : Player = Global.get_player()
	if player.inventory.has_item("Arrow"):
		look_at(get_global_mouse_position())
		var arrow = ARROW_SCENE.instantiate()
		arrow.global_position = $ShootPoint.global_position
		arrow.target = get_global_mouse_position()
		get_tree().current_scene.add_child(arrow)
		hit.emit()
		player.inventory.remove_item("Arrow")
