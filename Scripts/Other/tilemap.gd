extends TileMapLayer


func is_water_tile(pos : Vector2i) -> bool:
	var data = get_cell_tile_data(pos)
	if data:
		if data.get_custom_data("is_water"):
			return true
	return false


func is_sand_tile(pos : Vector2i) -> bool:
	var data = get_cell_tile_data(pos)
	if data:
		if data.get_custom_data("is_sand"):
			return true
	return false


func is_grass_tile(pos : Vector2i) -> bool:
	var data = get_cell_tile_data(pos)
	if data:
		if data.get_custom_data("is_grass"):
			return true
	return false


func interact(player : Player):
	if player.inventory.get_selected_item() is WaterContainer:
		var water_container : WaterContainer = player.inventory.get_selected_item()
		water_container.pollute()
		water_container.fill()
