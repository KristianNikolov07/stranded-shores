class_name Item
extends Resource

@export var item_name = ""
@export_range(1, 128, 1) var max_amount : int = 1
@export var texture : Texture2D
