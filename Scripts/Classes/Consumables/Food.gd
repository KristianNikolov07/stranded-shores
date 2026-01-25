@tool
class_name Food
extends Consumable

## The class for the food items

## The resource for the cooked version of the food, null if the food can't be cooked.
@export var cooked_version : Food

## Called when the food is cooked
func cook():
	if cooked_version != null:
		if Global.get_player().inventory.add_item(cooked_version.duplicate()):
			Global.get_player().inventory.remove_item(item_name)
