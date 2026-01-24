@tool
class_name Armor
extends Item

@export_range(0, 100) var defence : int
@export var max_durability : int
@export var durability : int

func take_durability(_durability : int = 1) -> void:
	durability -= _durability
	if durability <= 0:
		Global.get_player().inventory.set_armor(null)
