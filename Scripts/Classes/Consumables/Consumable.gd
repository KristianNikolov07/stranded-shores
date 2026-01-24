@tool
class_name Consumable
extends Item

@export var has_unlimited_uses = false
@export var speed_modifier : int
@export var running_speed_gain_modifier : int
@export var max_running_speed_modifier : int
@export var hunger_modifier : float
@export var thirst_modifier : float

func use(player : Player) -> void:
	player.base_speed += speed_modifier
	player.running_speed_gain += running_speed_gain_modifier
	player.max_running_speed += max_running_speed_modifier
	player.hunger_and_thirst.remove_hunger(hunger_modifier)
	player.hunger_and_thirst.remove_thirst(thirst_modifier)


func get_save_data() -> Dictionary:
	var data = {
		"amount": amount
	}
	return data


func load_save_data(data : Dictionary) -> void:
	amount = data.amount
