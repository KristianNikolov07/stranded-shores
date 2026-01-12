class_name Loot
extends Resource

@export var item : Item
@export var amount : int = 1
@export_range(1, 100, 1) var chance : int
