extends Control

var tool : Tool

@onready var player : Player = Global.get_player()

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		hide()
		reset()
		player.can_move = true
		accept_event()


func set_tool(_tool : Tool):
	if _tool.repair_item != null and _tool.durability < _tool.max_durability:
		tool = _tool
		%Material.texture = tool.repair_item.texture
		update_ui()


func reset() -> void:
	tool = null
	%Material.texture = null
	update_ui()


func update_ui():
	%Tool.set_item(tool)
	if tool != null:
		if tool.durability < tool.max_durability and player.inventory.has_item(tool.repair_item.item_name):
			%RepairButton.disabled = false
		else:
			%RepairButton.disabled = true
	else:
		%RepairButton.disabled = true


func _on_repair_button_pressed() -> void:
	if player.inventory.has_item(tool.repair_item.item_name):
		tool.repair()
		player.inventory.remove_item(tool.repair_item.item_name)
		update_ui()
