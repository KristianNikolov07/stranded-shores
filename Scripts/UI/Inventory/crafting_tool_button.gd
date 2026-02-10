extends Button

## A button used for selecting a CraftingTool

signal tool_selected(tool : CraftingTool)

@export var tool : CraftingTool

func _ready() -> void:
	icon = tool.texture


func _process(_delta: float) -> void:
	if Global.is_using_controller:
		focus_mode = Control.FOCUS_ALL
	else:
		focus_mode = Control.FOCUS_NONE


func _on_pressed() -> void:
	tool_selected.emit(tool)
