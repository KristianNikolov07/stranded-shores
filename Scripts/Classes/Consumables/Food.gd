@tool
class_name Food
extends Consumable

@export var hunger_modifier_when_cooked : float
@export var texture_when_cooked : Texture
@export var can_be_cooked = true
@export var is_cooked = false

func cook():
	if can_be_cooked:
		is_cooked = true
		hunger_modifier = hunger_modifier_when_cooked
		texture = texture_when_cooked


func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	var more_data = {
		"is_cooked": is_cooked,
	}
	data.merge(more_data)
	return data


func load_save_data(data : Dictionary) -> void:
	super.load_save_data(data)
	if data.is_cooked:
		cook()
