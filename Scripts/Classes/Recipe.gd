class_name Recipe
extends Resource

@export var tool : CraftingTool
@export var item1 : Item
@export var item1_amount : int = 1
@export var item2 : Item
@export var item2_amount : int = 1
@export var result : Item


func requires_crafting_table() -> bool:
	if tool != null:
		return true
	return false
