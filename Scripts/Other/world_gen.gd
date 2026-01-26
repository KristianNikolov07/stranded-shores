extends Node

## The script responsible for the world generation

const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")
const ROCK_ITEM = preload("res://Resources/Items/rock.tres")
const STICK_ITEM = preload("res://Resources/Items/stick.tres")

## The structures that the world generator attempts to place
@export var structures : Array[SpawnChance]
## The change form 1 to 100 that a rock item is placed
@export_range(1, 100, 1) var rock_spawn_chance = 5
## The change form 1 to 100 that a stick item is placed
@export_range(1, 100, 1) var stick_spawn_chance = 5 

@onready var tilemap : TileMapLayer = get_node("../Tilemap")
@onready var spawn_points_node : Node = get_node("../SpawnPoints")
@onready var player : Player = get_node("../Player")

func _ready() -> void:
	if SaveProgress.has_save():
		SaveProgress.load_save()
	else:
		generate_random_objects()
		get_parent().get_node("Forest").generate()
		choose_spawn_point()
		SaveProgress.get_node("PlaytimeCounter").start()
		await get_tree().physics_frame
		SaveProgress.save()


## Goes through the entire tilemap and attempts to place structures from
## the structures array
func generate_random_objects() -> void:
	for x in range(Global.TILEMAP_SIZE):
		for y in range(Global.TILEMAP_SIZE):
			
			# Structures
			if tilemap.is_grass_tile(Vector2i(x, y)):
				for structure in structures:
					if structure.roll_chance():
						var structure_node = structure.scene.instantiate()
						structure_node.global_position = Global.tilemap_coords_to_global_coords(Vector2i(x, y))
						get_parent().add_child.call_deferred(structure_node)
						break
				
			# Attempt to place a rock
			if tilemap.is_water_tile(Vector2i(x, y)) == false:
				var rock = DROPPED_ITEM_SCENE.instantiate()
				rock.item = ROCK_ITEM.duplicate()
				rock.can_despawn = false
				if attempt_to_place(rock, rock_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
			
			# Attempt to place a stick
			if tilemap.is_water_tile(Vector2i(x, y)) == false:
				var stick = DROPPED_ITEM_SCENE.instantiate()
				stick.item = STICK_ITEM.duplicate()
				stick.can_despawn = false
				if attempt_to_place(stick, stick_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue


## Attempts the place and object/structure at a specific position with a
## specific 1 to 100 chance
func attempt_to_place(object : Node, chance : int, pos : Vector2) -> bool:
	var random = randi_range(1, 100)
	if random <= chance:
		object.global_position = pos
		get_parent().add_child.call_deferred(object)
		return true
	else:
		return false


## Chooses the spawn point for the player
func choose_spawn_point() -> void:
	var rand = randi_range(0, spawn_points_node.get_child_count())
	var i = 0
	for child in spawn_points_node.get_children():
		if i == rand:
			player.global_position = child.global_position
			player.respawn_point = child.global_position
		i += 1
