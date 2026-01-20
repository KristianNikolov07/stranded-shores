class_name Recipe
extends Resource

@export var tool : CraftingTool
@export var item1 : ItemStack
@export var item2 : ItemStack
@export var result : ItemStack


func requires_crafting_table() -> bool:
	if tool != null:
		return true
	return false
