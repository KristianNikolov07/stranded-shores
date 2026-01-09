extends Area2D

func interact(player : Player) -> void:
	$CanvasLayer/RepairMenu.show()
	$CanvasLayer/RepairMenu.update_ui()
	player.repair_menu = $CanvasLayer/RepairMenu
	player.can_move = false
