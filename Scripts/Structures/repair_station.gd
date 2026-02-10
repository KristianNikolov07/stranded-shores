extends Structure

func interact(player : Player) -> void:
	$CanvasLayer/RepairMenu.open()
	player.repair_menu = $CanvasLayer/RepairMenu
	player.can_move = false
