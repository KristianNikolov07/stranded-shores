class_name WaterContainerStack
extends ItemStack

@export var water_amount : int
@export var is_water_clean : bool = false

func fill_water() -> void:
	if item is WaterContainer:
		water_amount = item.capacity
		
		# Water objective
		Global.get_player().objectives.complete_objective("water")


func clean_water() -> void:
	if item is WaterContainer:
		is_water_clean = true
		
		# Clean Water Objective
		Global.get_player().objectives.complete_objective("clean water")


func pollute_water() -> void:
	if item is WaterContainer:
		is_water_clean = false


func drink_water(player : Player) -> void:
	if item is WaterContainer:
		if water_amount > 0:
			item.use(player)
			water_amount -= 1
			if is_water_clean:
				player.hunger_and_thirst.player.remove_thirst(item.thirst_modifier_when_clean)
			else:
				player.hunger_and_thirst.player.remove_thirst(item.thirst_modifier_when_polluted)


func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	var new_data = {
		"water_amount": water_amount,
		"is_water_clean": is_water_clean
	}
	data.merge(new_data)
	return data


func load_save_data(data : Dictionary) -> void:
	super.load_save_data(data)
	water_amount = data.water_amount
	is_water_clean = data.is_water_clean
