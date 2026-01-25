class_name Structure
extends StaticBody2D

const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")

## The max amount of health the structure can have
@export var max_hp : int = 50
## The loot that the structure drops
@export var drops : Array[Loot]
## An array of the textures for when that structure is been broken
@export var broken_textures : Array[Texture]

## The current health of the structure
@onready var hp = max_hp

## Decreases the structure's health
func damage(dmg : int) -> void:
	hp -= dmg
	
	# Textures
	if broken_textures.is_empty() == false and hp > 0:
		@warning_ignore("integer_division")
		var damage_percent = float(max_hp - hp) / hp
		var texture_index = int(damage_percent * (broken_textures.size() - 1))
		$Sprite2D.texture = broken_textures[min(broken_textures.size() - 1, texture_index)]
		print(texture_index)
	
	# Audio
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
	
	if hp <= 0:
		destroy()


## Destroies the structure
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


## Gets the data that needs to be saved 
func get_save_data() -> Dictionary:
	var data = {
		"hp" = hp
	}
	return data


## Loades the save data
func load_save_data(data : Dictionary) -> void:
	hp = data.hp
