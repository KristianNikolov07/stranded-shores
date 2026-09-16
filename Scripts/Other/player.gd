class_name Player
extends CharacterBody2D

## The script responsible for the movement for the player and its interaction with
## the game world

## Whether or not the player can move, mostly used for when the player
## is looking in a UI/Menu
@export var can_move : bool = true
## The maximum amount of health the player can have
@export var max_hp : int = 100
## The maximum amount of distance the player can place structures at
@export var placement_range : float = 200

@export_group("Speed and Stamina")
## The speed of the player when he isn't running
@export var base_speed : float = 200
## The acceleration applied while running
@export var running_speed_gain : float = 2000
## The maximum amount of speed the player can have when running 
@export var max_running_speed = 400 
## The maximum amount if stamina the player can have
@export var max_stamina = 200
## The amount the stamina decreases by every second while running
@export var stamina_decrease_per_second = 30.0
## The amount the stamina increases by every second while not running
@export var stamina_recharge_per_second = 15.0

## Whether or not the player is currently running
var is_running = false
## The currently openned repair menu. Null if the repair menu is not open
var repair_menu : Control
## The currently openned chest menu. Null if a chest is not open
var chest_menu : Area2D
## The coordinates the player respawns at after death
var respawn_point : Vector2
## The currently used tool. Null if a tool isn't being used
var tool : Node2D = null

## The current amount of speed
@onready var speed = base_speed
## The current amount of stamina
@onready var stamina = max_stamina
## The current amount of health
@onready var hp = max_hp
@onready var inventory : Inventory = $UI/Inventory
@onready var crafting = $UI/CraftingMenu
@onready var hp_bar = $UI/Stats/HP
@onready var hunger_and_thirst = $HungerAndThirst
@onready var objectives = $UI/Objectives

func _ready() -> void:
	$Stamina.max_value = max_stamina
	$Stamina.value = max_stamina
	$Stamina.hide()
	
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	
	load_skin()


func _physics_process(delta: float) -> void:
	if can_move:
		velocity = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN") * speed

		# Running
		if Input.is_action_pressed("SPRINT") and stamina > 0 and $HungerAndThirst.can_sprint() and !is_in_water():
			is_running = true
			speed = min(speed + running_speed_gain * delta, max_running_speed)
			
			# Sprinting Objective
			objectives.complete_objective("sprint")
		else:
			is_running = false
			speed = base_speed
		
		if velocity != Vector2.ZERO:
			# Movement Objective
			objectives.complete_objective("movement")
		move_and_slide()
	
	# Stamina
	if is_running and velocity != Vector2.ZERO:
		stamina -= stamina_decrease_per_second * delta
	elif velocity != Vector2.ZERO: # Walking
		stamina += stamina_recharge_per_second * delta
		if stamina > max_stamina:
			stamina = max_stamina
	else: # Standing still
		stamina += stamina_recharge_per_second * 2 * delta
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
	
	# Animations
	if velocity == Vector2.ZERO:
		$PlayerSprite.start_idle()
	else:
		if is_running:
			$PlayerSprite.start_running()
		else:
			$PlayerSprite.start_walking()
		
		# Rotation
		if velocity.x < 0 and $PlayerSprite.scale.x > 0:
			print("left")
			$PlayerSprite.scale.x = -$PlayerSprite.scale.x
		elif velocity.x > 0 and $PlayerSprite.scale.x < 0:
			$PlayerSprite.scale.x = -$PlayerSprite.scale.x


func _input(event: InputEvent) -> void:
	# Inventory
	if event.is_action_pressed("ATTACK"):
		attack(inventory.selected_slot)
	if event.is_action_pressed("PLACE"):
		place(inventory.selected_slot)
	
	#Interactions
	elif event.is_action_pressed("INTERACT"):
		for object in $InteractionRange.get_overlapping_areas():
			# Objective
			objectives.complete_objective("interact")
			object.interact(self)
		for object in $InteractionRange.get_overlapping_bodies():
			# Objective
			objectives.complete_objective("interact")
			object.interact(self)


## Decreases the player's health
func damage(dmg : int, is_hunger_or_thirst = false) -> void:
	if inventory.armor != null and !is_hunger_or_thirst:
		if inventory.armor.durability > 0:
			hp -= max(0, dmg - inventory.armor.defence)
			inventory.armor.take_durability()
			inventory.visualize_inventory()
		else:
			hp -= dmg
	else:
		hp -= dmg
		
	hp_bar.value = hp
	if hp <= 0:
		kill()


## Checks whether or not the play is over a water tile
func is_in_water() -> bool:
	var tilemap = get_node("../Tilemap")
	if tilemap.is_water_tile(Global.global_coords_to_tilemap_coords(global_position)):
		return true
	else:
		return false


## Increases the player's health
func heal(_hp : int) -> void:
	hp += _hp
	if hp > max_hp:
		hp = max_hp
	hp_bar.value = hp


## Sets the player's health to a specific amount
func set_hp(_hp : int) -> void:
	hp = _hp
	hp_bar.value = hp


## Drops all of the player's items and shows the death screen
func kill() -> void:
	inventory.drop_inventory()
	can_move = false
	hide()
	$UI/DeathScreen.start()


## Sets the player's position to its respawn_point
func respawn() -> void:
	global_position = respawn_point
	show()
	can_move = true
	set_hp(max_hp)
	speed = base_speed
	stamina = max_stamina
	$HungerAndThirst.set_hunger(0)
	$HungerAndThirst.set_thirst(0)


## Uses the tool in the slot if the slot contains one, otherways does nothing
func attack(slot : int) -> void:
	if can_move:
		if inventory.items[slot] is Tool:
			if inventory.items[slot].durability > 0:
				if tool != null and tool.has_method("use"):
					tool.use()


## Uses the structure in the slot if the slot contains one, otherways does nothing
func place(slot : int) -> void:
	if can_move:
		if inventory.items[slot] is StructureItem:
			# Objectives
			objectives.check_structure_place(inventory.items[slot].item_name)
			if $StructurePreview.get_overlapping_bodies().size() == 0:
				inventory.items[slot].place(self, $StructurePreview.global_position)
				inventory.remove_item_from_slot(slot)
				inventory.reselect_slot()


func load_skin() -> void:
	var config = ConfigFile.new()
	var err = config.load(Global.SKIN_CUSTOMIZATIONS_FILE_PATH)
	if err != OK:
		return
	var hair = config.get_value("colors", "hair_color", $PlayerSprite.DEFAULT_HAIR_COLOR)
	var skin = config.get_value("colors", "skin_color", $PlayerSprite.DEFAULT_SKIN_COLOR)
	var shirt = config.get_value("colors", "shirt_color", $PlayerSprite.DEFAULT_SHIRT_COLOR)
	$PlayerSprite.set_hair_color(hair)
	$PlayerSprite.set_skin_color(skin)
	$PlayerSprite.set_shirt_color(shirt)
