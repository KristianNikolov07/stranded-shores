extends Node

## The script resposible for managing the hunger and the thirst of the player 

@export_group("Hunger")
## The current amount of hunger
@export var hunger : float = 0
## The maximum possible amount of hunger
@export var max_hunger : float = 10
## The amount of hunger the player gains each second
@export var hunger_per_second : float = 0.05
## The amount the hunger_per_second variable is multiplied by when the player is running 
@export var hunger_per_second_running_multipliar : float = 2
## The amount of damage the player gains each second when the hunger is at its max amount
@export var hunger_damage_per_second : int = 1
## The minimum amount of hunger that prevents the player's health from regenerating
@export var hunger_hp_regeneration_threshold : float = 6

@export_group("Thirst")
## The current amount of thirst
@export var thirst : float = 0
## The maximum possible amount of thirst
@export var max_thirst : float = 10
## The amount of hunger the player gains each second
@export var thirst_per_second : float = 0.1
## The amount thirst_per_second variable is multiplied by when the player is running 
@export var thirst_per_second_running_multipliar : float = 1.5
## The amount of damage the player gains each second when the thirst is at its max amount
@export var thirst_damage_per_second : int = 1
## The minimum amount of thirst that prevents the player's health from regenerating
@export var thirst_hp_regeneration_threshold : float = 8

@onready var player : Player = get_parent()
@onready var hunger_bar : TextureProgressBar = get_node("../UI/Stats/Hunger")
@onready var thirst_bar : TextureProgressBar = get_node("../UI/Stats/Thirst")

func _ready() -> void:
	hunger_bar.max_value = max_hunger
	thirst_bar.max_value = max_thirst


func _process(delta: float) -> void:
	if player.is_running and player.velocity != Vector2.ZERO:
		add_thirst(delta * thirst_per_second * thirst_per_second_running_multipliar)
		add_hunger(delta * hunger_per_second * hunger_per_second_running_multipliar)
	add_thirst(delta * thirst_per_second)
	add_hunger(delta * hunger_per_second)


## Increases the hunger
func add_hunger(_hunger : float = 1) -> void:
	hunger += _hunger
	if hunger > max_hunger:
		hunger = max_hunger
	hunger_bar.value = hunger


## Decreases the hunger
func remove_hunger(_hunger : float) -> void:
	hunger -= _hunger
	if hunger < 0:
		hunger = 0
	hunger_bar.value = hunger


## Sets the hunger to a specific amount
func set_hunger(_hunger : float) -> void:
	hunger = _hunger
	hunger_bar.value = hunger


## Sets the hunger per second
func set_hunger_per_second(time : float) -> void:
	hunger_per_second = time


## Increases the thirst
func add_thirst(_thirst : float = 1) -> void:
	thirst += _thirst
	if thirst > max_thirst:
		thirst = max_thirst
	thirst_bar.value = thirst


## Decreases the thirst
func remove_thirst(_thirst : float) -> void:
	thirst -= _thirst
	if thirst < 0:
		thirst = 0
	thirst_bar.value = thirst


## Sets the thirst to a specific amount
func set_thirst(_thirst : float) -> void:
	thirst = _thirst
	thirst_bar.value = thirst


## Sets the thirst per second
func set_thirst_per_second(time : float) -> void:
	thirst_per_second = time


## Checks whether or not the player can sprint depending on the thirst and hunger
func can_sprint() -> bool:
	if hunger < max_hunger and thirst < max_thirst:
		return true
	else:
		return false


func _on_timer_timeout() -> void:
	if hunger == max_hunger:
		player.damage(hunger_damage_per_second, true)
	elif thirst == max_thirst:
		player.damage(thirst_damage_per_second, true)
		
	elif thirst < thirst_hp_regeneration_threshold:
		if !player.is_running:
			player.heal(thirst_damage_per_second)
	elif hunger < hunger_hp_regeneration_threshold:
		if !player.is_running:
			player.heal(hunger_damage_per_second)
