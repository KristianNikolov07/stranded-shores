class_name ItemStack
extends Resource

@export var item : Item
@export var amount : int = 1

##Returns the leftover amount
func increase_amount(_amount : int) -> int:
	amount += _amount
	if amount > item.max_amount:
		var left_over = amount - item.max_amount
		amount = item.max_amount
		return left_over
	else:
		return 0


func decrease_amount(_amount : int) -> void:
	amount -= _amount


func get_save_data() -> Dictionary:
	var data = {
		"amount": amount,
	}
	return data


func load_save_data(data : Dictionary) -> void:
	amount = data.amount
