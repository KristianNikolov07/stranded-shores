@tool
class_name Consumable
extends Item

## The class for the Consumable items

## Whether or not the consumble can be used an infinate 
## amount of times
@export var has_unlimited_uses = false
## The amount the speed gets modified by, after the items is consumed
@export var speed_modifier : int
## The amount the running speed gain gets modified by, 
## after the items is consumed
@export var running_speed_gain_modifier : int
## The amount the max running speed gets modified by, 
## after the items is consumed
@export var max_running_speed_modifier : int
## The amount the hunger gets modified by, after the items is consumed
@export var hunger_modifier : float
## The amount the thirst gets modified by, after the items is consumed
@export var thirst_modifier : float

## Called when the consumable is consumed
func use(player : Player) -> void:
	player.base_speed += speed_modifier
	player.running_speed_gain += running_speed_gain_modifier
	player.max_running_speed += max_running_speed_modifier
	player.hunger_and_thirst.remove_hunger(hunger_modifier)
	player.hunger_and_thirst.remove_thirst(thirst_modifier)


## Gets the data that needs to be saved 
func get_save_data() -> Dictionary:
	var data = {
		"amount": amount
	}
	return data


## Loades the save data
func load_save_data(data : Dictionary) -> void:
	amount = data.amount
