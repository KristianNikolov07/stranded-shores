@tool
class_name Item
extends Resource

## The base class for the Items

## The name of the item
@export var item_name = ""
## The max stack size
@export_range(1, 128, 1) var max_amount : int = 1
## The texture of the item
@export var texture : Texture2D
## A button that sets the item_path variable
@export_tool_button("Set Path") var item_path_button = set_item_path
## Variable used the preserve the resource path through duplicates
@export_file_path() var item_path

## The current amount of the item
var amount : int = 1

## Sets assigns the resource_path to the item_path variable
func set_item_path() -> void:
	if resource_path != "":
		item_path = resource_path


## Increases the item's amount. Returns the leftover amount
func increase_amount(_amount : int) -> int:
	amount += _amount
	if amount > max_amount:
		var left_over = amount - max_amount
		amount = max_amount
		return left_over
	else:
		return 0

## Decreases the item's amount.
func decrease_amount(_amount : int) -> void:
	amount -= _amount

## Gets the data that needs to be saved 
func get_save_data() -> Dictionary:
	var data = {
		"amount": amount
	}
	return data

## Loades the save data
func load_save_data(data : Dictionary) -> void:
	amount = data.amount
