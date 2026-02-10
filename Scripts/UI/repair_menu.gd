extends Control

var tool : Tool

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


func open() -> void:
	show()
	update_ui()
	
	if Global.is_using_controller:
		var i : int = 0
		for item_slot in Global.get_player().inventory.get_node("Inventory").get_children():
			item_slot.set_right_focus_neighbor(%RepairButton)
			if i == 0:
				item_slot.focus()
				%RepairButton.focus_neighbor_left = item_slot.get_path()
			i += 1


func set_tool(_tool : Tool):
	if _tool != null and _tool is Tool: 
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
		player.inventory.visualize_inventory()
		update_ui()
