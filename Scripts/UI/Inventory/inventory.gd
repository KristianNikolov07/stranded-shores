class_name Inventory
extends Control

const ITEM_SLOT_SCENE = preload("res://Scenes/UI/Inventory/item_slot.tscn")
const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")

@export var items : Array[Item]
@export var inventory_size = 4
@export var armor : Armor
@export var backpack_item : Backpack

var selected_slot = 0
var opened_storage : Storage

@onready var player = get_node("../../")
@onready var backpack : Storage = get_node("../Backpack")

func _ready() -> void:
	items.resize(inventory_size)
	initiate_inventory_UI()
	select_slot(0)


func _input(event: InputEvent) -> void:
	if event.is_action_released("PreviousItem"):
		if selected_slot == 0:
			select_slot(inventory_size - 1)
		else:
			select_slot(selected_slot - 1)
	if event.is_action_released("NextItem"):
		if selected_slot == inventory_size - 1:
			select_slot(0)
		else:
			select_slot(selected_slot + 1)
	if event.is_action_pressed("Item0"):
		select_slot(0)
	if event.is_action_pressed("Item1"):
		select_slot(1)
	if event.is_action_pressed("Item2"):
		select_slot(2)
	if event.is_action_pressed("Item3"):
		select_slot(3)
	if event.is_action_pressed("DropItem"):
		if Input.is_action_pressed("DropAll"):
			drop_item(selected_slot, true)
		else:
			drop_item(selected_slot, false)
	if event.is_action_pressed("UseItem"):
		use_item(selected_slot)
	if event.is_action_pressed("ToggleBackpack"):
		if backpack.is_open():
			player.can_move = true
			opened_storage = null
			backpack.hide()
		elif backpack.items.size() > 0:
			if player.can_move:
				player.can_move = false
				opened_storage = backpack
				backpack.open()


func add_item(item : Item, bypass_backpack : bool = false) -> bool:
	# Rocks and Sticks Objective
	if item.item_name == "Rock":
		if has_item("Stick", 10) and has_item("Rock", 9):
			player.objectives.complete_objective("sticks and rocks")
	elif item.item_name == "Stick":
		if has_item("Rock", 10) and has_item("Stick", 9):
			player.objectives.complete_objective("sticks and rocks")
	
	# Wood Objective
	if item.item_name == "Wood":
		if has_item("Wood", 1):
			player.objectives.complete_objective("gather wood")
	
	# Iron Objective
	if item.item_name == "Iron Ore":
		if has_item("Iron Ore", 9):
			player.objectives.complete_objective("iron")
	
	
	if has_item(item.item_name):
		for i in range(items.size()):
			if items[i] != null:
				if items[i].item_name == item.item_name:
					var left_over = items[i].increase_amount(item.amount)
					item.decrease_amount(item.amount - left_over)
					visualize_inventory()
					if left_over == 0:
						reselect_slot()
						return true
	
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item.duplicate()
			items[i].amount = item.amount
			visualize_inventory()
			reselect_slot()
			return true
	
	if backpack_item != null and bypass_backpack == false:
		if backpack.add_item(item):
			return true
	return false


func has_item(item_name : String, amount = 1) -> bool:
	var count = 0
	
	if backpack_item != null:
		count += backpack.get_item_amount(item_name)
	
	for i in range(inventory_size):
		if items[i] != null and items[i].item_name == item_name:
			count += items[i].amount
	if count >= amount:
		return true
	else:
		return false


func remove_item(item_name : String, amount = 1) -> bool:
	if backpack_item != null:
		if backpack.has_item(item_name, amount):
			backpack.remove_item(item_name, amount)
			
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			items[i].decrease_amount(amount)
			if items[i].amount <= 0:
				items[i] = null
			visualize_inventory()
			return true
	return false


func remove_item_from_slot(slot : int, amount = 1) -> bool:
	if items[slot] != null:
		items[slot].decrease_amount(amount)
		if items[slot].amount <= 0:
			items[slot] = null
		visualize_inventory()
		return true
	else:
		return false


func get_selected_item() -> Item:
	return items[selected_slot]


func move_item_to_storage(slot : int):
	if items[slot] != null:
		if opened_storage != null:
			if opened_storage.add_item(items[slot]):
				remove_item_from_slot(slot, items[slot].amount)


func select_slot(slot : int) -> void:
	if slot < inventory_size:
		selected_slot = slot
		visualize_selected_slot()
	
	# Tools
	if player.tool != null:
		player.tool.queue_free()
		player.tool = null
	if items[slot] is Tool:
		var tool : Tool = items[slot]
		var tool_node = tool.tool_scene.instantiate()
		player.add_child(tool_node)
		player.tool = tool_node
		if player.tool.has_signal("hit"):
			player.tool.hit.connect(decrease_durability)
	
	# Structures
	if items[slot] is StructureItem:
		player.get_node("StructurePreview").show()
		player.get_node("StructurePreview/TextureRect").texture = items[selected_slot].preview_texture
	else:
		player.get_node("StructurePreview").hide()


## Refreshes the currently selected slot
func reselect_slot():
	select_slot(selected_slot)


func drop_item(slot : int, drop_all = false) -> void:
	if items[slot] != null:
		
		# Prevent boats from being dropped when in water
		if items[slot] is Boat and player.is_in_water():
			return
		
		var node = DROPPED_ITEM_SCENE.instantiate()
		node.item = items[slot].duplicate()
		if drop_all:
			node.item.amount = items[slot].amount
		node.global_position = player.global_position
		player.get_parent().add_child(node)
		if drop_all:
			remove_item_from_slot(slot, items[slot].amount)
		else:
			remove_item_from_slot(slot, 1)
		
		reselect_slot()


func decrease_durability() -> void:
	if items[selected_slot] is Tool:
		items[selected_slot].take_durability()
		if items[selected_slot].durability <= 0: # Make sure the tool stops being used after it breaks
			if player.tool.has_method("stop_using"):
				player.tool.stop_using()
		visualize_inventory()


func use_item(slot : int) -> void:
	if player.can_move:
		if items[slot] != null:
			if items[slot] is Consumable:
				items[slot].use(player)
				if !items[slot].has_unlimited_uses:
					remove_item_from_slot(slot)
			elif items[slot] is Armor:
				equip_armor_from_slot(slot)
			elif items[slot] is Backpack:
				equip_backpack_from_slot(slot)


func set_items(_items : Array[Item]) -> void:
	items = _items
	visualize_inventory()


func set_armor(_armor : Armor) -> void:
	if _armor == null:
		armor = null
	else:
		armor = _armor.duplicate()
	visualize_inventory()


func set_backpack(_backpack : Backpack) -> void:
	if _backpack == null:
		backpack_item = null
		backpack.set_inv_size(0)
	else:
		backpack_item = _backpack.duplicate()
		backpack.set_inv_size(backpack_item.size)
	visualize_inventory()


func equip_armor_from_slot(slot : int) -> void:
	if armor == null:
		set_armor(items[slot].duplicate())
		remove_item_from_slot(slot)
	else:
		var temp = armor.duplicate()
		set_armor(items[slot].duplicate())
		remove_item_from_slot(slot)
		add_item(temp.duplicate())


func equip_backpack_from_slot(slot):
	if backpack_item == null:
		set_backpack(items[slot].duplicate())
		remove_item_from_slot(slot)
	elif backpack_item.size < items[slot].size:
		var temp = backpack_item.duplicate()
		set_backpack(items[slot].duplicate())
		remove_item_from_slot(slot)
		add_item(temp.duplicate())


func unequip_armor() -> void:
	if armor != null:
		if add_item(armor.duplicate()):
			set_armor(null)


func unequip_backpack() -> void:
	if backpack_item != null and backpack.is_empty():
		if add_item(backpack_item.duplicate(), true):
			set_backpack(null)


func drop_armor() -> void:
	if armor != null:
		var dropped_item = DROPPED_ITEM_SCENE.instantiate()
		dropped_item.item = armor
		dropped_item.global_position = player.global_position
		armor = null
		player.get_parent().add_child(dropped_item)


func drop_backpack_item() -> void:
	if backpack_item != null:
		var dropped_item = DROPPED_ITEM_SCENE.instantiate()
		dropped_item.item = backpack_item
		dropped_item.global_position = player.global_position
		backpack_item = null
		player.get_parent().add_child(dropped_item)


func drop_inventory() -> void:
	for i in range(inventory_size):
		drop_item(i, true)
	drop_armor()
	if backpack_item != null:
		backpack.drop_all_items()
		drop_backpack_item()


# UI
func initiate_inventory_UI():
	for i in range(inventory_size):
		var node = ITEM_SLOT_SCENE.instantiate()
		node.id = i
		$Inventory.add_child(node)
	$Inventory.get_child(0).select()

func visualize_inventory():
	for i in range(items.size()):
		$Inventory.get_child(i).set_item(items[i])
	$ArmorSlot.set_item(armor)
	$BackpackSlot.set_item(backpack_item)


func visualize_selected_slot():
	for child in $Inventory.get_children():
		child.deselect()
	$Inventory.get_child(selected_slot).select()
