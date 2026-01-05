class_name Storage
extends GridContainer

@export var items : Array[Item]

var item_slot_scene = preload("res://Scenes/UI/Inventory/item_slot.tscn")
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if is_open():
			player.can_move = true
			player.inventory.opened_storage = null
			hide()
			accept_event()


func set_inv_size(new_size : int) -> void:
	items.resize(new_size)


func open() -> void:
	update_storage()
	show()


func is_open() -> bool:
	if visible:
		return true
	else:
		return false


func is_empty() -> bool:
	for i in range(items.size()):
		if items[i] != null:
			return false
	return true


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


func set_items(_items : Array[Item]) -> void:
	items = _items
	update_storage()


func has_item(item_name : String, amount = 1) -> bool:
	if get_item_amount(item_name) >= amount:
		return true
	else:
		return false


func remove_item(item_name : String, amount = 1) -> bool:
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			items[i].decrease_amount(amount)
			if items[i].amount <= 0:
				items[i] = null
			update_storage()
			return true
	return false


func get_item_amount(item_name : String) -> int:
	var count = 0
	for i in range(items.size()):
		if items[i] != null and items[i].item_name == item_name:
			count += items[i].amount
	return count


func remove_item_from_slot(slot : int, amount = 1) -> void:
	if items[slot] != null:
		items[slot].decrease_amount(amount)
		if items[slot].amount <= 0:
			items[slot] = null
			update_storage()


func remove_item_from_storage(slot : int) -> void:
	if items[slot] != null:
		if player.inventory.add_item(items[slot], true):
			remove_item_from_slot(slot, items[slot].amount)


func drop_all_items() -> void:
	for i in range(items.size()):
		if items[i] != null:
			var dropped_item = dropped_item_scene.instantiate()
			dropped_item.item = items[i].duplicate()
			dropped_item.global_position = get_node("../../").global_position
			remove_item_from_slot(i, items[i].amount)
			get_node("../../../").add_child(dropped_item)


func update_storage() -> void:
	for slot in get_children():
		slot.queue_free()
	
	for i in range(items.size()):
		var slot = item_slot_scene.instantiate()
		slot.set_item(items[i])
		slot.id = i
		slot.is_in_backpack = true
		add_child(slot, true)
	
