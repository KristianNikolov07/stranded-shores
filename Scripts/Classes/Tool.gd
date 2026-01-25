@tool
class_name Tool
extends Item

## The base class for the tools and weapons

## The PackedScene of the tool
@export var tool_scene : PackedScene
## The max amount of durability the tool can have
@export var max_durability = 100
## The amount of durability the tool currently has
@export var durability = 100
## The item that the tool needs in order to be repaired
@export var repair_item : Item
## The amount that is repaired with a single repair_item
@export var repair_amount : int = 1
## The texture for when the tool is broken
@export var broken_texture : Texture
## The texture for when the tool is repaired
@export var repaired_texture : Texture

## Increases the tools durability
func repair() -> void:
	durability += repair_amount
	if durability > max_durability:
		durability = max_durability
	if repaired_texture != null:
		texture = repaired_texture


## Decreases the tools durability
func take_durability(_durability = 1) -> void:
	durability -= _durability
	if durability <= 0:
		durability = 0
		if broken_texture != null:
			texture = broken_texture


func get_save_data() -> Dictionary:
	var data = {
		"amount": amount,
		"durability": durability
	}
	return data


func load_save_data(data : Dictionary) -> void:
	amount = data.amount
	durability = data.durability
	if durability <= 0:
		if broken_texture != null:
			texture = broken_texture
