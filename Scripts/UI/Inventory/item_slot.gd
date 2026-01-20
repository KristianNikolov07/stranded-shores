extends Control

enum Type{
	ITEM,
	ARMOR,
	BACKPACK
}

@export var type : Type = Type.ITEM
@export var is_in_backpack = false
@export var is_in_chest = false
@export var id : int
@export var can_be_clicked = true

var selected = false

@onready var player : Player = Global.get_player()

func set_item(item_stack : ItemStack) -> void:
	if item_stack != null and item_stack.item != null:
		$Outline.hide()
		
		# Item texture
		$Item.texture = item_stack.item.texture
		if item_stack.amount > 1:
			$MarginContainer/Amount.text = str(item_stack.amount)
			$MarginContainer/Amount.show()
		else:
			$MarginContainer/Amount.hide()
		
		# Durability
		if item_stack.item is Tool or item_stack.item is Armor:
			$MarginContainer/Durability.max_value = item_stack.item.max_durability
			if item_stack.durability == item_stack.item.max_durability:
				$MarginContainer/Durability.hide()
			else:
				$MarginContainer/Durability.value = item_stack.durability
				$MarginContainer/Durability.show()
		else:
			$MarginContainer/Durability.hide() 
		
		# Water Amount
		if item_stack.item is WaterContainer:
			$MarginContainer/Water.show()
			$MarginContainer/Water.max_value = item_stack.item.capacity
			$MarginContainer/Water.value = item_stack.water_amount
		else:
			$MarginContainer/Water.hide()
	
	else:
		$Outline.show()
		$Item.texture = null
		$MarginContainer/Amount.hide()
		$MarginContainer/Durability.hide() 
		$MarginContainer/Water.hide()


func select() -> void:
	selected = true
	$Selector.show()


func deselect() -> void:
	selected = false
	$Selector.hide()

# TODO
func _on_button_pressed() -> void:
	if can_be_clicked:
		if player.repair_menu != null:
			player.repair_menu.set_tool(player.inventory.items[id])
		elif type == Type.ARMOR:
			get_parent().unequip_armor()
		elif type == Type.BACKPACK:
			get_parent().unequip_backpack()
		else:
			if is_in_backpack:
				get_parent().remove_item_from_storage(id)
			else:
				get_node("../../").move_item_to_storage(id)
