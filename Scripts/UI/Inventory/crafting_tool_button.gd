extends Button

signal tool_selected(tool : CraftingTool)

@export var tool : CraftingTool

func _ready() -> void:
	icon = tool.texture


func _on_pressed() -> void:
	tool_selected.emit(tool)
