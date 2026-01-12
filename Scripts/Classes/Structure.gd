class_name Structure
extends StaticBody2D

const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")

@export var max_hp : int = 50
@export var drops : Array[Loot]
@export var broken_textures : Array[Texture]

@onready var hp = max_hp

func damage(dmg : int) -> void:
	hp -= dmg
	
	if broken_textures.is_empty() == false and hp > 0:
		@warning_ignore("integer_division")
		var damage_percent = float(max_hp - hp) / hp
		var texture_index = int(damage_percent * (broken_textures.size() - 1))
		$Sprite2D.texture = broken_textures[min(broken_textures.size() - 1, texture_index)]
		print(texture_index)
		
	if hp <= 0:
		destroy()


func destroy() -> void:
	for loot in drops:
		var rand = randi_range(1, 100)
		if rand <= loot.chance:
			var dropped_item = DROPPED_ITEM_SCENE.instantiate()
			dropped_item.global_position = global_position
			dropped_item.item = loot.item.duplicate()
			dropped_item.item.amount = loot.amount
			get_tree().current_scene.call_deferred("add_child", dropped_item)
	queue_free()


func get_save_data() -> Dictionary:
	var data = {
		"hp" = hp
	}
	return data


func load_save_data(data : Dictionary) -> void:
	hp = data.hp
