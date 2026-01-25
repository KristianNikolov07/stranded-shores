@tool
class_name WaterContainer
extends Consumable

## The class for the Water Containers

## The max amount of water that the water container can store
@export var capacity : int = 1
## The amount the thirst gets modified by, when the water is clean
@export var thirst_modifier_when_clean : float
## The amount the thirst gets modified by, when the water is polluted
@export var thirst_modifier_when_polluted : float
## The max amount of water that is currently stored inside of the container
@export var water_amount : int = 0
## Whether or not the water is clean
@export var is_clean = false

func _init() -> void:
	has_unlimited_uses = true


## Fills the container with water
func fill() -> void:
	var player : Player = Global.get_player()
	water_amount = capacity
	player.inventory.visualize_inventory()
	
	# Water objective
	Global.get_player().objectives.complete_objective("water")


## Cleans the water inside of the container
func clean() -> void:
	is_clean = true
	thirst_modifier = thirst_modifier_when_clean
	
	# Clean Water Objective
	Global.get_player().objectives.complete_objective("clean water")


## Pollutes the water inside of the container
func pollute() -> void:
	is_clean = false
	thirst_modifier = thirst_modifier_when_polluted

## Called when the container is being drunk from.
func use(player : Player) -> void:
	if water_amount > 0:
		super.use(player)
		water_amount -= 1
		player.inventory.visualize_inventory()
	
