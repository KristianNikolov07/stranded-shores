extends Control

const RADAR_ICON_SCENE = preload("res://Scenes/UI/radar_icon.tscn")


func update() -> void:
	for child in get_children():
		child.queue_free()
	for structure : Structure in get_tree().get_nodes_in_group("Radar"):
		var radar_icon = RADAR_ICON_SCENE.instantiate()
		radar_icon.structure_pos = structure.global_position
		radar_icon.texture = structure.radar_texture
		add_child(radar_icon)
