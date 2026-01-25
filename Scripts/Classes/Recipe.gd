class_name Recipe
extends Resource

## The base class for the crafting recipes

## The crafting tool needed for the recipe. Null if the recipe doesn't use a tool
@export var tool : CraftingTool
## The first ingredient of the recipe
@export var item1 : Item
## The amount of the first ingredient of the recipe needed
@export var item1_amount : int = 1
## The second ingredient of the recipe, null if the recipe uses a tool instead
@export var item2 : Item
## The amount of the second ingredient of the recipe needed
@export var item2_amount : int = 1
## The result of the recipe
@export var result : Item


## Checks whether or not the recipe requires a workbench in order the be crafted
func requires_crafting_table() -> bool:
	if tool != null:
		return true
	return false
