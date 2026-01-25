@tool
class_name StructureItem
extends Item

## The base class for the items that are used to place a structure

## The PackedScene of the structure that is placed
@export var structure_scene : PackedScene
## The texture that is used for the placement preview before the structure is placed
@export var preview_texture : Texture

## Places the structure
func place(player : Player, placement_location : Vector2) -> void:
	var structure_node = structure_scene.instantiate()
	structure_node.global_position = placement_location
	player.get_parent().add_child(structure_node)
