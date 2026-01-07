extends Area2D

const APPLE = preload("res://Resources/Items/Food/apple.tres")

func interact(player : Player) -> void:
	if get_parent().has_apples:
		if player.inventory.add_item(APPLE.duplicate()):
			get_parent().remove_apples()
