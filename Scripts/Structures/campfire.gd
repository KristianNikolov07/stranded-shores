extends Structure

func interact(player : Player) -> void:
	if player.inventory.get_selected_item() is Food:
		player.inventory.get_selected_item().cook()
		player.inventory.visualize_inventory()
