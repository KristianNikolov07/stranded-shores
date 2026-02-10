extends Control

## Used for visualising an item from the player's inventory

## Emitted when the slot in clicked
signal clicked(id : int)

enum Type{
	ITEM,
	ARMOR,
	BACKPACK
}

## The Type of Item the slot can visualise
@export var type : Type = Type.ITEM
## The id of the slot. 
## Coresponds to the index of the item inside the inventory Array
@export var id : int
## Whether or not the slot can be clicked
@export var can_be_clicked = true

## Whether or not the item is currently in use
var selected = false
## Whether or not the item slot is currently selected for the purpose of moving its item
var highlighted = false

@onready var player : Player = Global.get_player()

func set_item(item : Item) -> void:
	if item != null:
		$Background.hide()
		
		# Item texture
		$Item.texture = item.texture
		if item.amount > 1:
			$MarginContainer/Amount.text = str(item.amount)
			$MarginContainer/Amount.show()
		else:
			$MarginContainer/Amount.hide()
		
		# Durability
		if item is Tool or item is Armor:
			$MarginContainer/Durability.max_value = item.max_durability
			if item.durability == item.max_durability:
				$MarginContainer/Durability.hide()
			else:
				$MarginContainer/Durability.value = item.durability
				$MarginContainer/Durability.show()
		else:
			$MarginContainer/Durability.hide() 
		
		# Water Amount
		if item is WaterContainer:
			$MarginContainer/Water.show()
			$MarginContainer/Water.max_value = item.capacity
			$MarginContainer/Water.value = item.water_amount
		else:
			$MarginContainer/Water.hide()
	
	else:
		$Background.show()
		$Item.texture = null
		$MarginContainer/Amount.hide()
		$MarginContainer/Durability.hide() 
		$MarginContainer/Water.hide()


func focus() -> void:
	$Button.grab_focus()

## Used in storages so that the focus is able to move from the storage to
## the inventory 
func set_left_focus_neighbor(neighbor : Control) -> void:
	$Button.focus_neighbor_left = neighbor.get_path()

## Used so that the focus is able to move from the inventory to
## the opened storage
func set_right_focus_neighbor(neighbor : Control) -> void:
	$Button.focus_neighbor_right = neighbor.get_path()


func select() -> void:
	selected = true
	$Selector.show()


func deselect() -> void:
	selected = false
	$Selector.hide()


func highlight() -> void:
	highlighted = true
	$Highlighter.show()


func dehighlight() -> void:
	highlighted = false
	$Highlighter.hide()


func _on_button_pressed() -> void:
	if can_be_clicked:
		if player.repair_menu != null:
			if player.inventory.items[id] is Tool:
				player.repair_menu.set_tool(player.inventory.items[id])
		clicked.emit(id)


func _on_button_focus_entered() -> void:
	if Global.is_using_controller:
		$ControllerSelector.show()


func _on_button_focus_exited() -> void:
	$ControllerSelector.hide()
