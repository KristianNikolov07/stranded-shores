class_name Loot
extends Resource

## The base class for the loot dropped by entities or structures

## The item that drops
@export var item : Item
## The amount of the item that drops
@export var amount : int = 1
## The chance from 1 to 100 that the item drops
@export_range(1, 100, 1) var chance : int
