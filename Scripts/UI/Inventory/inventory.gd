class_name Inventory
extends Control

## The script responcible for the player's inventory system

const ITEM_SLOT_SCENE = preload("res://Scenes/UI/Inventory/item_slot.tscn")
const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")

## An array of the items the player currently has
@export var items : Array[Item]
## The amount of item slots the player's inventory has
@export var inventory_size = 4
## The currently equipped armor. Null if the player doesn't have an equpped armor
@export var armor : Armor
## The currently equipped backpack. Null if the player doesn't have an equpped backpack
@export var backpack_item : Backpack

## The item slot the is currently in use
var selected_slot = 0
## The item slot that is selected for the purpose of moving its item
var highlighted_slot = null
## The Storage that is currently open. Null if a storage isn't an open 
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

## Adds an item the the inventory, if it is full, the player has a backpack equipped and
## bypass_backpack is false that item attempts to be placed in the backpack.
## Returns True if the item is successfully added to the inventory or backpack, and false
## if it is not.
func add_item(item : Item, bypass_backpack : bool = false) -> bool:
	if has_item(item.item_name):
		for i in range(items.size()):
			if items[i] != null:
				if items[i].item_name == item.item_name:
					var left_over = items[i].increase_amount(item.amount)
					item.decrease_amount(item.amount - left_over)
					visualize_inventory()
					if left_over == 0:
						reselect_slot()
						player.objectives.check_item()
						return true
	
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item.duplicate()
			items[i].amount = item.amount
			visualize_inventory()
			reselect_slot()
			player.objectives.check_item()
			return true
	
	if backpack_item != null and bypass_backpack == false:
		if backpack.add_item(item):
			player.objectives.check_item()
			return true
	return false


## Checks the inventory and backpack(if there is one) for a specific item and amount
func has_item(item_name : String, amount : int = 1) -> bool:
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


## Removes an item from the inventory and backpack(if there is one). Returns True
## if the removal is successful
func remove_item(item_name: String, amount: int = 1) -> bool:
	var remaining : int = amount

	if backpack_item != null and remaining > 0:
		var from_backpack : int = min(remaining, backpack.get_item_amount(item_name))
		if from_backpack > 0:
			backpack.remove_item(item_name, from_backpack)
			remaining -= from_backpack

	if remaining <= 0:
		visualize_inventory()
		return true

	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			var take : int = min(remaining, items[i].amount)
			items[i].decrease_amount(take)
			remaining -= take
			if items[i].amount <= 0:
				items[i] = null
			if remaining <= 0:
				visualize_inventory()
				return true

	visualize_inventory()
	return false


## Removes an item from a specific slot
func remove_item_from_slot(slot : int, amount = 1) -> bool:
	if items[slot] != null:
		items[slot].decrease_amount(amount)
		if items[slot].amount <= 0:
			items[slot] = null
		visualize_inventory()
		return true
	else:
		return false


## Gets the item in the selected_slot
func get_selected_item() -> Item:
	return items[selected_slot]


## Selects a specific slot
func select_slot(slot : int) -> void:
	if slot < inventory_size:
		selected_slot = slot
		visualize_inventory()
	
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


## Drops an item/items from a slot
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


## If the item in the selected_slot is a Tool, decreases the durability
func decrease_durability() -> void:
	if items[selected_slot] is Tool:
		items[selected_slot].take_durability()
		if items[selected_slot].durability <= 0: # Make sure the tool stops being used after it breaks
			if player.tool.has_method("stop_using"):
				player.tool.stop_using()
		visualize_inventory()


## Attempts to use an item in a specific slot
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


## Sets the array of Items
func set_items(_items : Array[Item]) -> void:
	items = _items
	visualize_inventory()


## Sets the armor
func set_armor(_armor : Armor) -> void:
	if _armor == null:
		armor = null
	else:
		armor = _armor.duplicate()
	visualize_inventory()


## Sets the backpack
func set_backpack(_backpack : Backpack) -> void:
	if _backpack == null:
		backpack_item = null
		backpack.set_inv_size(0)
	else:
		backpack_item = _backpack.duplicate()
		backpack.set_inv_size(backpack_item.size)
	visualize_inventory()


## Equips an armor from a specific slot
func equip_armor_from_slot(slot : int) -> void:
	if armor == null:
		set_armor(items[slot].duplicate())
		remove_item_from_slot(slot)
	else:
		var temp = armor.duplicate()
		set_armor(items[slot].duplicate())
		remove_item_from_slot(slot)
		add_item(temp.duplicate())


## Equips a backpack from a specific slot
func equip_backpack_from_slot(slot):
	if backpack_item == null:
		set_backpack(items[slot].duplicate())
		remove_item_from_slot(slot)
	elif backpack_item.size < items[slot].size:
		var temp = backpack_item.duplicate()
		set_backpack(items[slot].duplicate())
		remove_item_from_slot(slot)
		add_item(temp.duplicate())


## Attempts to unequip the armor
func unequip_armor() -> void:
	if armor != null:
		if add_item(armor.duplicate()):
			set_armor(null)


## Attempts to unequip the backpack
func unequip_backpack() -> void:
	if backpack_item != null and backpack.is_empty():
		if add_item(backpack_item.duplicate(), true):
			set_backpack(null)


## Drops the player's armor on the ground
func drop_armor() -> void:
	if armor != null:
		var dropped_item = DROPPED_ITEM_SCENE.instantiate()
		dropped_item.item = armor
		dropped_item.global_position = player.global_position
		armor = null
		player.get_parent().add_child(dropped_item)


## Drops the player's backpack on the ground
func drop_backpack_item() -> void:
	if backpack_item != null:
		var dropped_item = DROPPED_ITEM_SCENE.instantiate()
		dropped_item.item = backpack_item
		dropped_item.global_position = player.global_position
		set_backpack(null)
		player.get_parent().add_child(dropped_item)
		visualize_inventory()


## Drops all items in the inventory on the ground
func drop_inventory() -> void:
	for i in range(inventory_size):
		drop_item(i, true)
	drop_armor()
	if backpack_item != null:
		backpack.drop_all_items()
		drop_backpack_item()
	visualize_inventory()


## Swaps two items in the inventory
func swap_items(slot1: int, slot2: int, move_to_storage: bool = false) -> void:
	var src := items
	var dst : Array[Item]
	if move_to_storage:
		dst = opened_storage.items
	else:
		dst = items

	var src_item = src[slot1]
	if src_item == null:
		return

	var dst_item = dst[slot2]

	# Stacking
	if dst_item != null and src_item.item_name == dst_item.item_name and dst_item.amount < dst_item.max_amount:
		var left_over = dst_item.increase_amount(src_item.amount)
		src_item.decrease_amount(src_item.amount - left_over)
		if src_item.amount == 0:
			src[slot1] = null

		visualize_inventory()
		if move_to_storage:
			opened_storage.update_storage()
		return

	# Swapping
	src[slot1] = dst_item
	dst[slot2] = src_item

	visualize_inventory()
	if move_to_storage:
		opened_storage.update_storage()


func highlight_slot(slot : int) -> void:
	if items[slot] != null:
		if highlighted_slot == null:
			highlighted_slot = slot
		elif highlighted_slot == slot:
			highlighted_slot = null
		visualize_inventory()


func dehighlight_current_slot() -> void:
	highlighted_slot = null
	visualize_inventory()


func _on_item_slot_clicked(id : int) -> void:
	if highlighted_slot == null and (opened_storage == null or opened_storage.highlighted_slot == null):
		highlight_slot(id)
	else:
		if opened_storage == null or opened_storage.highlighted_slot == null:
			swap_items(highlighted_slot, id)
			dehighlight_current_slot()
		else:
			opened_storage.swap_items(opened_storage.highlighted_slot, id, true)
			opened_storage.dehighlight_current_slot()


func _on_armor_slot_clicked(_id: int) -> void:
	if highlighted_slot != null:
		if items[highlighted_slot] is Armor:
			equip_armor_from_slot(highlighted_slot)
			dehighlight_current_slot()
	else:
		unequip_armor()


func _on_backpack_slot_clicked(_id: int) -> void:
	if highlighted_slot != null:
		if items[highlighted_slot] is Backpack:
			equip_backpack_from_slot(highlighted_slot)
			dehighlight_current_slot()
	else:
		unequip_backpack()


# UI
func initiate_inventory_UI():
	for i in range(inventory_size):
		var node = ITEM_SLOT_SCENE.instantiate()
		node.id = i
		$Inventory.add_child(node)
		node.clicked.connect(_on_item_slot_clicked)
	$Inventory.get_child(0).select()


## Updates the player's inventory
func visualize_inventory():
	for i in range(items.size()):
		$Inventory.get_child(i).set_item(items[i])
	$ArmorSlot.set_item(armor)
	$BackpackSlot.set_item(backpack_item)
	
	# Selected and Highlighted Slots
	for child in $Inventory.get_children():
		child.deselect()
		child.dehighlight()
	$Inventory.get_child(selected_slot).select()
	if highlighted_slot != null:
		$Inventory.get_child(highlighted_slot).highlight()
