extends Structure

func interact(player : Player) -> void:
	if player.inventory.get_selected_item().item is Food:
		player.inventory.get_selected_item().item.cook()
		player.inventory.visualize_inventory()
		
		# Objective
		player.objectives.complete_objective("food")
