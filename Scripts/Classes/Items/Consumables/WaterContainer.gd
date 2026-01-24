class_name WaterContainer
extends Consumable

@export var capacity : int = 1
@export var thirst_modifier_when_clean : float
@export var thirst_modifier_when_polluted : float

func _init() -> void:
	has_unlimited_uses = true
