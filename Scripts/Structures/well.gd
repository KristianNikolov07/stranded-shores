extends Structure

func interact(player : Player) -> void:
	if player.inventory.get_selected_item().item is WaterContainer:
		var water_container : WaterContainer = player.inventory.get_selected_item().item
		if water_container.water_amount == 0:
			water_container.clean()
		water_container.fill()
