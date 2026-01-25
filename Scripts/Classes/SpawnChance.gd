class_name SpawnChance
extends Resource

## A resource used for deciding whether or not an entity should spawn 
## and whether or not a structure should be placed 

## The PackedScene of the entity or structure the be placed 
@export var scene : PackedScene
## The chance from 1 to 100 that the entity or structure has to be placed
@export_range(1, 100, 1) var chance : int

## Rolls the spawn chance. Reture true if the entity or structure should be placed
func roll_chance() -> bool:
	if chance >= randi_range(1, 100):
		return true
	else:
		return false
