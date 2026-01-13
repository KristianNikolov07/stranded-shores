class_name Entity
extends CharacterBody2D

@export var max_hp = 100
@export var speed = 50
@export var loot_table : Array[Loot]
@export var can_despawn = true
@export var despawn_distance = 1000

var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")
var hp = max_hp

@onready var main_scene = get_tree().current_scene


func _process(_delta: float) -> void:
	var player : Player = Global.get_player()
	if player.global_position.distance_to(global_position) > despawn_distance:
		queue_free()


func damage(dmg : int) -> void:
	hp -= dmg
	$Sprite2D.self_modulate = Color(1, 0, 0, $Sprite2D.self_modulate.a)
	if hp <= 0:
		call_deferred("kill")
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.self_modulate = Color(1, 1, 1, $Sprite2D.self_modulate.a)


func kill() -> void:
	for loot in loot_table:
		var rand = randi_range(1, 100)
		if rand < loot.chance:
			var dropped_item = dropped_item_scene.instantiate()
			dropped_item.global_position = global_position
			dropped_item.item = loot.item
			dropped_item.item.amount = loot.amount
			main_scene.add_child(dropped_item)
	queue_free()
