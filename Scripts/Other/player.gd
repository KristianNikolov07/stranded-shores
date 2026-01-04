class_name Player
extends CharacterBody2D

@export var can_move = true
@export var max_hp = 100
@export var placement_range = 200

@export_group("Speed and Stamina")
@export var base_speed = 200
@export var running_speed_gain = 5
@export var max_running_speed = 400 
@export var max_stamina = 200
@export var stamina_decrease_per_second = 0.5
@export var stamina_recharge_per_second = 0.25

var is_running = false
var repair_menu : Control
var chest_menu : Area2D

@onready var speed = base_speed
@onready var stamina = max_stamina
@onready var hp = max_hp
@onready var inventory = $UI/Inventory
@onready var crafting = $UI/CraftingMenu
@onready var hp_bar = $UI/Stats/HP
@onready var hunger_and_thirst = $HungerAndThirst

func _ready() -> void:
	$Stamina.max_value = max_stamina
	$Stamina.value = max_stamina
	$Stamina.hide()
	
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	


func _process(_delta: float) -> void:
	if can_move:
		velocity = Input.get_vector("Left", "Right", "Up", "Down") * speed
		
		# Running
		if Input.is_action_pressed("Sprint") and stamina > 0 and $HungerAndThirst.can_sprint() and !is_in_water():
			is_running = true
			speed += speed / running_speed_gain
			if speed > max_running_speed:
				speed = max_running_speed
		else:
			is_running = false
			speed = base_speed
		
		move_and_slide()
	
	# Stamina
	if is_running and velocity != Vector2.ZERO:
		stamina -= stamina_decrease_per_second
	elif velocity != Vector2.ZERO: # Walking
		stamina += stamina_recharge_per_second
		if stamina > max_stamina:
			stamina = max_stamina
	else: # Standing still
		stamina += stamina_recharge_per_second * 2
		if stamina > max_stamina:
			stamina = max_stamina
	if stamina != max_stamina:
		$Stamina.show()
		$Stamina.value = stamina
	else:
		$Stamina.hide()
	
	# Structure Preview
	if inventory.items[inventory.selected_slot] is StructureItem:
		if abs(global_position.x - get_global_mouse_position().x) < placement_range:
			$StructurePreview.global_position.x = get_global_mouse_position().x
		if abs(global_position.y - get_global_mouse_position().y) < placement_range:
			$StructurePreview.global_position.y = get_global_mouse_position().y
	
	# Boat
	if inventory.has_item("Boat"):
		set_collision_mask_value(1, false)
	else:
		set_collision_mask_value(1, true)


func _input(event: InputEvent) -> void:
	# Inventory
	if event.is_action_pressed("Attack"):
		attack(inventory.selected_slot)
	if event.is_action_pressed("Place"):
		place(inventory.selected_slot)
	
	#Interactions
	elif event.is_action_pressed("Interact"):
		if $InteractionRange.get_overlapping_areas().size() > 0:
			$InteractionRange.get_overlapping_areas()[0].interact(get_node("."))
		elif $InteractionRange.get_overlapping_bodies().size() > 0:
			$InteractionRange.get_overlapping_bodies()[0].interact(get_node("."))


func damage(damage : int, is_hunger_or_thirst = false) -> void:
	if inventory.armor != null and !is_hunger_or_thirst:
		if inventory.armor.durability > 0:
			hp -= damage - inventory.armor.defence
			inventory.armor.take_durability()
			inventory.visualize_inventory()
		else:
			hp -= damage
	else:
		hp -= damage
		
	hp_bar.value = hp
	if hp <= 0:
		respawn()


func is_in_water() -> bool:
	var tilemap = get_node("../Tilemap")
	if tilemap.is_water_tile(Global.global_coords_to_tilemap_coords(global_position)):
		return true
	else:
		return false


func heal(_hp : int) -> void:
	hp += _hp
	if hp > max_hp:
		hp = max_hp
	hp_bar.value = hp


func set_hp(_hp : int) -> void:
	hp = _hp
	hp_bar.value = hp


func respawn() -> void:
	inventory.drop_inventory()
	global_position = get_node("../SpawnPoints").get_child(0).global_position
	set_hp(max_hp)
	speed = base_speed
	stamina = max_stamina
	$HungerAndThirst.set_hunger(0)
	$HungerAndThirst.set_thirst(0)


func attack(slot : int) -> void:
	if can_move:
		if inventory.items[slot] is Tool:
			if inventory.items[slot].durability > 0:
				$Tools.get_child(0).use()


func place(slot : int) -> void:
	if can_move:
		if inventory.items[slot] is StructureItem:
			if $StructurePreview.get_overlapping_bodies().size() == 0:
				inventory.items[slot].place(self, $StructurePreview.global_position)
				inventory.remove_item_from_slot(slot)
				inventory.reselect_slot()
