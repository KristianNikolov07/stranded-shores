class_name StructureItem
extends Item

@export var structure_scene : PackedScene
@export var preview_texture : Texture

func place(player : Player, placement_location : Vector2) -> void:
	var structure_node = structure_scene.instantiate()
	structure_node.global_position = placement_location
	player.get_parent().add_child(structure_node)
