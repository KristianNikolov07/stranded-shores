extends Node

@export_group("Hunger")
@export var hunger : float = 0
@export var max_hunger : float = 10
@export var hunger_per_second : float = 0.05
@export var hunger_per_second_running_multipliar = 2
@export var hunger_damage_per_second = 1
@export var hunger_hp_regeneration_threshold : float = 6

@export_group("Thirst")
@export var thirst : float = 0
@export var max_thirst : float = 10
@export var thirst_per_second : float = 0.1
@export var thirst_per_second_running_multipliar = 1.5
@export var thirst_damage_per_second = 1
@export var thirst_hp_tick_time = 3
@export var thirst_hp_regeneration_threshold : float = 8

@onready var player : Player = get_parent()
@onready var hunger_bar : ProgressBar = get_node("../UI/Stats/Hunger")
@onready var thirst_bar : ProgressBar = get_node("../UI/Stats/Thirst")

func _ready() -> void:
	hunger_bar.max_value = max_hunger
	thirst_bar.max_value = max_thirst


func _process(delta: float) -> void:
	if player.is_running:
		add_thirst(delta * thirst_per_second * thirst_per_second_running_multipliar)
		add_hunger(delta * hunger_per_second * hunger_per_second_running_multipliar)
	add_thirst(delta * thirst_per_second)
	add_hunger(delta * hunger_per_second)


func add_hunger(_hunger : float = 1):
	hunger += _hunger
	if hunger > max_hunger:
		hunger = max_hunger
	hunger_bar.value = hunger


func remove_hunger(_hunger : float):
	hunger -= _hunger
	if hunger < 0:
		hunger = 0
	hunger_bar.value = hunger


func set_hunger(_hunger : float):
	hunger = _hunger
	hunger_bar.value = hunger


func set_hunger_per_second(time : float):
	hunger_per_second = time


func add_thirst(_thirst : float = 1):
	thirst += _thirst
	if thirst > max_thirst:
		thirst = max_thirst
	thirst_bar.value = thirst


func remove_thirst(_thirst : float):
	thirst -= _thirst
	if thirst < 0:
		thirst = 0
	thirst_bar.value = thirst


func set_thirst(_thirst : float):
	thirst = _thirst
	thirst_bar.value = thirst


func set_thirst_per_second(time : float):
	thirst_per_second = time


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
