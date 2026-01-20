extends Control

var tool_stack : ItemStack

@onready var player : Player = Global.get_player()

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			hide()
			reset()
			player.can_move = true
			player.repair_menu = null
			accept_event()


func set_tool(_tool_stack : ItemStack):
	if _tool_stack != null and _tool_stack.item is Tool:
		if _tool_stack.item.repair_item != null and _tool_stack.durability < _tool_stack.max_durability:
			tool_stack = _tool_stack
			%Material.texture = tool_stack.item.repair_item.texture
			update_ui()


func reset() -> void:
	tool_stack = null
	%Material.texture = null
	update_ui()


func update_ui():
	%Tool.set_item(tool_stack)
	if tool_stack != null:
		if tool_stack.durability < tool_stack.item.max_durability and player.inventory.has_item(tool_stack.item.repair_item.item_name):
			%RepairButton.disabled = false
		else:
			%RepairButton.disabled = true
	else:
		%RepairButton.disabled = true


func _on_repair_button_pressed() -> void:
	if player.inventory.has_item(tool_stack.item.repair_item.item_name):
		tool_stack.repair()
		player.inventory.remove_item(tool_stack.item.repair_item.item_name)
		player.inventory.visualize_inventory()
		update_ui()
