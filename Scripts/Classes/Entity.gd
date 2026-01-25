class_name Entity
extends CharacterBody2D

## The base class for the Entities

const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")

## The max amount of health the entity can have
@export var max_hp = 100
## The speed or the entity
@export var speed = 50
## The loot the entity drops when killed
@export var loot_table : Array[Loot]
## Whether or not the entity can despawn
@export var can_despawn = true
## The distance the entity needs the be at in order the despawn
@export var despawn_distance = 1000

@onready var main_scene = get_tree().current_scene
## The current health of the entity
@onready var hp = max_hp

func _process(_delta: float) -> void:
	var player : Player = Global.get_player()
	if player.global_position.distance_to(global_position) > despawn_distance:
		queue_free()


## Decreases the entity's health from the entities
func damage(dmg : int) -> void:
	hp -= dmg
	$Sprite2D.self_modulate = Color(1, 0, 0, $Sprite2D.self_modulate.a)
	if hp <= 0:
		call_deferred("kill")
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.self_modulate = Color(1, 1, 1, $Sprite2D.self_modulate.a)


## Kills the entity
func kill() -> void:
	for loot in loot_table:
		var rand = randi_range(1, 100)
		if rand < loot.chance:
			var dropped_item = DROPPED_ITEM_SCENE.instantiate()
			dropped_item.global_position = global_position
			dropped_item.item = loot.item.duplicate()
			dropped_item.item.amount = loot.amount
			main_scene.add_child(dropped_item)
	queue_free()
