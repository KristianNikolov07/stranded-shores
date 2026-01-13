extends Node

const TREE_SCENE = preload("res://Scenes/Structures/tree.tscn")
const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")
const ROCK_ITEM = preload("res://Resources/Items/rock.tres")
const STICK_ITEM = preload("res://Resources/Items/stick.tres")
const BIG_ROCK_SCENE = preload("res://Scenes/Structures/big_rock.tscn")
const SMALL_IRON_ORE_SCENE = preload("res://Scenes/Structures/small_iron_ore.tscn")
const IRON_ORE_SCENE = preload("res://Scenes/Structures/iron_ore.tscn")

@export_range(0, 100, 1) var tree_spawn_chance = 10
@export_range(0, 100, 1) var big_rock_spawn_chance = 3
@export_range(0, 100, 1) var small_iron_ore_spawn_chance = 2
@export_range(0, 100, 1) var iron_ore_spawn_chance = 1
@export_range(0, 100, 1) var rock_spawn_chance = 5
@export_range(0, 100, 1) var stick_spawn_chance = 5

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
		get_parent().get_node("Forest").generate()
		choose_spawn_point()
		SaveProgress.save()


func generate_random_objects() -> void:
	for x in range(Global.TILEMAP_SIZE):
		for y in range(Global.TILEMAP_SIZE):
			
			# Attempt to place a tree
			if tilemap.is_grass_tile(Vector2i(x, y)):
				var tree = TREE_SCENE.instantiate()
				if attempt_to_place(tree, tree_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
			
			# Attempt to place a big rock
			if tilemap.is_grass_tile(Vector2i(x, y)):
				var big_rock = BIG_ROCK_SCENE.instantiate()
				if attempt_to_place(big_rock, big_rock_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
			
			# Attempt to place a small iron ore
			if tilemap.is_grass_tile(Vector2i(x, y)):
				var small_iron_ore = SMALL_IRON_ORE_SCENE.instantiate()
				if attempt_to_place(small_iron_ore, small_iron_ore_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
			
			# Attempt to place an iron ore
			if tilemap.is_grass_tile(Vector2i(x, y)):
				var iron_ore = IRON_ORE_SCENE.instantiate()
				if attempt_to_place(iron_ore, iron_ore_spawn_chance, Global.tilemap_coords_to_global_coords(Vector2(x, y))):
					continue
				
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
			player.respawn_point = child.global_position
		i += 1
