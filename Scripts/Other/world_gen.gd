extends Node

@export_range(0, 100, 1) var tree_spawn_chance = 10
@export_range(0, 100, 1) var rock_spawn_chance = 5
@export_range(0, 100, 1) var stick_spawn_chance = 5

var tree_scene = preload("res://Scenes/Structures/tree.tscn")
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")
var rock_item = preload("res://Resources/Items/rock.tres")
var stick_item = preload("res://Resources/Items/stick.tres")

var grass_tile_atlas_coords = Vector2i(0, 0)
var sand_tile_atlas_coords = Vector2i(1, 0)
var water_tile_atlas_coords = Vector2i(2, 0)

@onready var tilemap : TileMapLayer = get_node("../Tilemap")
@onready var spawn_points_node : Node = get_node("../SpawnPoints")
@onready var player : Player = get_node("../Player")

func _ready() -> void:
	if SaveProgress.has_save():
		SaveProgress.load_save()
	else:
		generate_random_objects()
		choose_spawn_point()
		SaveProgress.save()


func generate_random_objects() -> void:
	for x in range(Global.tilemap_size):
		for y in range(Global.tilemap_size):
			
			# Attempt to place a tree
			if tilemap.is_grass_tile(Vector2i(x, y)):
				var tree = tree_scene.instantiate()
				if attempt_to_place(tree, tree_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
				
			# Attempt to place a rock
			if tilemap.is_water_tile(Vector2i(x, y)) == false:
				var rock = dropped_item_scene.instantiate()
				rock.item = rock_item.duplicate()
				rock.can_despawn = false
				if attempt_to_place(rock, rock_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
			
			# Attempt to place a stick
			if tilemap.is_water_tile(Vector2i(x, y)) == false:
				var stick = dropped_item_scene.instantiate()
				stick.item = stick_item.duplicate()
				stick.can_despawn = false
				if attempt_to_place(stick, stick_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue


func attempt_to_place(object : Node, chance : int, pos : Vector2) -> bool:
	var random = randi_range(0, 100)
	if random <= chance:
		object.global_position = pos
		get_parent().add_child.call_deferred(object)
		return true
	else:
		return false


func choose_spawn_point() -> void:
	var rand = randi_range(0, spawn_points_node.get_child_count())
	var i = 0
	for child in spawn_points_node.get_children():
		if i == rand:
			player.global_position = child.global_position
		else:
			child.queue_free()
		i += 1
