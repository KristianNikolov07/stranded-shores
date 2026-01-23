extends Control

signal clicked(id : int)

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
			player.repair_menu.set_tool(player.inventory.items[id])
		clicked.emit(id)
