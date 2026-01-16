extends Node2D

const TREE_SCENE = preload("res://Scenes/Structures/tree.tscn")

## Radius in tilemap tile
@export var radius : float 
@export var inner_radius : float 
@export_range(0, 100, 1) var tree_spawn_chance = 50

func generate() -> void:
	generate_trees()


func generate_trees() -> void:
	var center = Global.global_coords_to_tilemap_coords(global_position)
	for x in range(-radius, radius):
		for y in range(-radius, radius):
			var point = center + Vector2(x, y)
			if center.distance_to(point) <= radius and center.distance_to(point) > inner_radius:
				print(point)
				if get_tree().current_scene.has_node("Tilemap") == false or get_tree().current_scene.get_node("Tilemap").is_grass_tile(point):
					if randi_range(1, 100) < tree_spawn_chance:
						var tree = TREE_SCENE.instantiate()
						tree.global_position = Global.tilemap_coords_to_global_coords(point)
						get_tree().current_scene.call_deferred("add_child", tree)
