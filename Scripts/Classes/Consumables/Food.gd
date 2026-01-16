@tool
class_name Food
extends Consumable

@export var cooked_version : Food

func cook():
	if cooked_version != null:
		if Global.get_player().inventory.add_item(cooked_version.duplicate()):
			Global.get_player().inventory.remove_item(item_name)
