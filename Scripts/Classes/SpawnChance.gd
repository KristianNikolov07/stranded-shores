class_name SpawnChance
extends Resource

@export var scene : PackedScene
@export_range(1, 100, 1) var change : int

func roll_chance() -> bool:
	if change >= randi_range(1, 100):
		return true
	else:
		return false
