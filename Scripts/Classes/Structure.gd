class_name Structure
extends StaticBody2D

@export var hp : int = 50
@export var drops : Array[Loot]

var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

func damage_with_axe(damage : int) -> void:
	hp -= damage
	if hp <= 0:
		destroy()


func destroy() -> void:
	for loot in drops:
		var rand = randi_range(1, 100)
		if rand < loot.chance:
			var dropped_item = dropped_item_scene.instantiate()
			dropped_item.global_position = global_position
			dropped_item.item = loot.item
			dropped_item.item.amount = loot.amount
			get_tree().current_scene.add_child(dropped_item)
	queue_free()


func get_save_data() -> Dictionary:
	var data = {
		"hp" = hp
	}
	return data


func load_save_data(data : Dictionary) -> void:
	hp = data.hp
