class_name ToolStack
extends ItemStack

@export var durability : int

func take_durability(_durability : int = 1) -> void:
	if item is Tool or item is Armor:
		durability -= _durability
		if durability <= 0:
			if item is Armor:
				Global.get_player().inventory.set_armor(null)
			elif item is Tool:
				durability = 0


func repair() -> void:
	if item is Tool:
		durability += item.repair_amount
		if durability > item.max_durability:
			durability = item.max_durability


func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	var new_data = {
		"durability": durability
	}
	data.merge(new_data)
	return data


func load_save_data(data : Dictionary) -> void:
	super.load_save_data(data)
	durability = data.durability
