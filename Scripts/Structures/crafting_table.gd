extends Area2D

func interact(player : Player) -> void:
	player.crafting.open_menu(true)
