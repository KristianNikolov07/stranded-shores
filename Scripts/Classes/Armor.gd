@tool
class_name Armor
extends Item

## The base class for the armor items

## The amount of damage the armor absorbs
@export_range(0, 100) var defence : int
## The max amount of durability the armor can have
@export var max_durability : int
## The amount of durability the armor currently has
@export var durability : int

## Decreases the durability or the armor
func take_durability(_durability : int = 1) -> void:
	durability -= _durability
	if durability <= 0:
		Global.get_player().inventory.set_armor(null)


func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	var new_data = {
		"durability": durability
	}
	data.merge(new_data)
	return data


func load_save_data(data : Dictionary) -> void:
	super.load_save_data(data)
	if data.has("durability"):
		durability = data.durability
