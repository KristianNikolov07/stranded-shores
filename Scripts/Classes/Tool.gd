@tool
class_name Tool
extends Item

@export var tool_scene : PackedScene
@export var max_durability = 100
@export var durability = 100
@export var repair_item : Item
@export var repair_amount : int = 1
@export var broken_texture : Texture
@export var repaired_texture : Texture

func repair() -> void:
	durability += repair_amount
	if durability > max_durability:
		durability = max_durability
	if repaired_texture != null:
		texture = repaired_texture


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
