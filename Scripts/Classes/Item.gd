@tool
class_name Item
extends Resource

@export var item_name = ""
@export_range(1, 128, 1) var max_amount : int = 1
@export var texture : Texture2D
@export_tool_button("Set Path") var item_path_button = set_item_path
@export_file_path() var item_path

var amount : int = 1

func set_item_path() -> void:
	item_path = resource_path


##Returns the leftover amount
func increase_amount(_amount : int) -> int:
	amount += _amount
	if amount > max_amount:
		var left_over = amount - max_amount
		amount = max_amount
		return left_over
	else:
		return 0


func decrease_amount(_amount : int) -> void:
	amount -= _amount


func get_save_data() -> Dictionary:
	var data = {
		"amount": amount
	}
	return data


func load_save_data(data : Dictionary) -> void:
	amount = data.amount
