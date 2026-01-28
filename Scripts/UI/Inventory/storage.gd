class_name Storage
extends GridContainer

const ITEM_SLOT_SCENE = preload("res://Scenes/UI/Inventory/item_slot.tscn")
const DROPPED_ITEM_SCENE = preload("res://Scenes/Objects/dropped_item.tscn")

## An array of the items currently stored inside the Storage
@export var items : Array[Item]

## The item slot that is selected for the purpose of moving its item
var highlighted_slot = null

@onready var player : Player = Global.get_player()

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if is_open():
			player.can_move = true
			player.inventory.opened_storage = null
			hide()
			accept_event()


## Sets the amount of item slots that Storage has
func set_inv_size(new_size : int) -> void:
	items.resize(new_size)


## Opens the Storage UI
func open() -> void:
	initiate_storage()
	show()


## Checks whether or not the Storage's UI is open
func is_open() -> bool:
	if visible:
		return true
	else:
		return false


## Checks whether or not the Storage is empty
func is_empty() -> bool:
	for i in range(items.size()):
		if items[i] != null:
			return false
	return true


## Adds an item the the Storage.  
## Returns True if the item is successfully added to the Storage and false
## if it is not.
func add_item(item : Item) -> bool:
	if has_item(item.item_name):
		for i in range(items.size()):
			if items[i] != null:
				if items[i].item_name == item.item_name:
					var left_over = items[i].increase_amount(item.amount)
					item.decrease_amount(item.amount - left_over)
					update_storage()
					if left_over == 0:
						return true
	
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item.duplicate()
			items[i].amount = item.amount
			update_storage()
			return true
	
	return false


## Sets the array of Items
func set_items(_items : Array[Item]) -> void:
	items = _items
	update_storage()

## Checks the Storage for a specific item and amount
func has_item(item_name : String, amount = 1) -> bool:
	if get_item_amount(item_name) >= amount:
		return true
	else:
		return false

## Removes an item from the Storage. Returns True
## if the removal is successful
func remove_item(item_name : String, amount = 1) -> bool:
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			items[i].decrease_amount(amount)
			if items[i].amount <= 0:
				items[i] = null
			update_storage()
			return true
	return false


## Gets the amount of a specific item in the Storage
func get_item_amount(item_name : String) -> int:
	var count = 0
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			count += items[i].amount
	return count


## Removes an item from a specific slot
func remove_item_from_slot(slot : int, amount = 1) -> void:
	if items[slot] != null:
		items[slot].decrease_amount(amount)
		if items[slot].amount <= 0:
			items[slot] = null
		update_storage()


## Drops all items in the Storage on the ground
func drop_all_items() -> void:
	for i in range(items.size()):
		if items[i] != null:
			var dropped_item = DROPPED_ITEM_SCENE.instantiate()
			dropped_item.item = items[i].duplicate()
			dropped_item.global_position = get_node("../../").global_position
			remove_item_from_slot(i, items[i].amount)
			get_node("../../../").add_child(dropped_item)


## Swaps two items in the Storage
func swap_items(slot1: int, slot2: int, remove_from_storage: bool = false) -> void:
	var src := items
	var dst : Array[Item]
	if remove_from_storage:
		dst = player.inventory.items
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

		update_storage()
		if remove_from_storage:
			player.inventory.visualize_inventory()
		return

	# Swapping
	src[slot1] = dst_item
	dst[slot2] = src_item

	update_storage()
	if remove_from_storage:
		player.inventory.visualize_inventory()


func highlight_slot(slot : int) -> void:
	if items[slot] != null:
		if highlighted_slot == null:
			highlighted_slot = slot
		elif highlighted_slot == slot:
			highlighted_slot = null
		update_storage()


func dehighlight_current_slot() -> void:
	highlighted_slot = null
	update_storage()


func _on_item_slot_clicked(id : int) -> void:
	if highlighted_slot == null and player.inventory.highlighted_slot == null:
		highlight_slot(id)
	else:
		if highlighted_slot != null:
			swap_items(highlighted_slot, id)
			dehighlight_current_slot()
		else:
			player.inventory.swap_items(player.inventory.highlighted_slot, id, true)
			player.inventory.dehighlight_current_slot()


func initiate_storage() -> void:
	for slot in get_children():
		slot.queue_free()
	
	for i in range(items.size()):
		var slot = ITEM_SLOT_SCENE.instantiate()
		slot.set_item(items[i])
		slot.id = i
		add_child(slot, true)
		slot.clicked.connect(_on_item_slot_clicked)


func update_storage() -> void:
	if visible:
		for i in range(items.size()):
			get_child(i).set_item(items[i])
		
		#Highlighted Slots
		for child in get_children():
			child.dehighlight()
		if highlighted_slot != null:
			get_child(highlighted_slot).highlight()
