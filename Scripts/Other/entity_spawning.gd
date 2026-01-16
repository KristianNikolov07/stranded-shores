extends Node

const PASSIVE_ENTITY_CAP = 20
const ENEMY_CAP = 20

@export var passiveEntityes : Array[SpawnChance]
@export var enemies : Array[SpawnChance]
@export var min_distance_from_player : float
@export var max_distance_from_player : float
@export var spawn_amount = 5

var spawn_check_scene = preload("res://Scenes/Systems/spawn_check.tscn")

@onready var day_night_cycle: DirectionalLight2D = $"../DayNightCycle"
@onready var player: Player = %Player

func check_position(pos : Vector2) -> bool:
	var spawn_check : Area2D = spawn_check_scene.instantiate()
	spawn_check.global_position = pos
	get_tree().current_scene.add_child(spawn_check)
	await get_tree().physics_frame
	if spawn_check.get_overlapping_bodies().is_empty():
		spawn_check.queue_free()
		return true
	else:
		spawn_check.queue_free()
		return false


func _on_spawn_attempt_timeout() -> void:
	var entity_spawn : SpawnChance
	if day_night_cycle.is_night and get_tree().get_nodes_in_group("Enemies").size() < ENEMY_CAP:
		entity_spawn = enemies.pick_random()
	elif day_night_cycle.is_night == false and get_tree().get_nodes_in_group("PassiveEntities").size() < PASSIVE_ENTITY_CAP:
		entity_spawn = passiveEntityes.pick_random()
	
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
