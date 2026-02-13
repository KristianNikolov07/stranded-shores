extends Node

## The script responcible for the spawning of entities

const SPAWN_CHECK_SCENE = preload("res://Scenes/Systems/spawn_check.tscn")

## The maximum possible amount of passive entities
const PASSIVE_ENTITY_CAP = 20
## The maximum possible amount of enemies
const ENEMY_CAP = 20

## The passive entities to spawn
@export var passiveEntityes : Array[SpawnChance]
## The enemies to spawn
@export var enemies : Array[SpawnChance]
## The minimum amount of distance the entity needs to be from the player in order the spawn
@export var min_distance_from_player : float
## The maximum amount of distance the entity can be from the player in order the spawn
@export var max_distance_from_player : float
## The amount of entities that try to spawn each attempt
@export var spawn_amount = 5

@onready var day_night_cycle: DirectionalLight2D = $"../DayNightCycle"
@onready var player: Player = %Player

## Checks whether or not the entity can spawn at a surtain position
func check_position(pos : Vector2) -> bool:
	var spawn_check : Area2D = SPAWN_CHECK_SCENE.instantiate()
	spawn_check.global_position = pos
	get_tree().current_scene.add_child(spawn_check)
	await get_tree().physics_frame
	await get_tree().physics_frame
	if spawn_check.get_overlapping_bodies().is_empty():
		spawn_check.queue_free()
		return true
	else:
		spawn_check.queue_free()
		return false


## Attempts to spawn the entities
func spawn() -> void:
	var entities : Array[SpawnChance]
	if day_night_cycle.is_night and get_tree().get_nodes_in_group("Enemies").size() < ENEMY_CAP:
		entities = enemies
	elif day_night_cycle.is_night == false and get_tree().get_nodes_in_group("PassiveEntities").size() < PASSIVE_ENTITY_CAP:
		entities = passiveEntityes
	
	for entity_spawn in entities:
		if entity_spawn != null:
			for i in range(spawn_amount):
				if entity_spawn.roll_chance():
					
					# Choose Position
					var distance : Vector2
					distance.x = randf_range(min_distance_from_player, max_distance_from_player)
					distance.y = randf_range(min_distance_from_player, max_distance_from_player)
					if randi_range(0, 1) == 0:
						distance.x = -distance.x
					if randi_range(0, 1) == 0:
						distance.y = -distance.y
					var position : Vector2 = player.global_position + distance
					
					if await check_position(position):
						var entity = entity_spawn.scene.instantiate()
						entity.global_position = position
						get_parent().add_child(entity)

func _on_spawn_attempt_timeout() -> void:
	spawn()
