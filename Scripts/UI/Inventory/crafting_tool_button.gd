extends Control

signal tool_selected(tool : Recipe.CraftingTool)

@export var tool : Recipe.CraftingTool

func _on_pressed() -> void:
	tool_selected.emit(tool)
