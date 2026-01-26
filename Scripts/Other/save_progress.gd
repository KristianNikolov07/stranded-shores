extends Node

## The script responsible for the saving and loading of the game's progress

const SAVES_FOLDER = "user://saves/"
const PLAYER_STATS_FILE_NAME = "player_stats.ini"
const WORLD_FILE_NAME = "world.json"

## The name of the save
@export var save_name = ""

var config = ConfigFile.new()
var json = JSON.new()

func _ready() -> void:
	get_window().close_requested.connect(_on_windows_close_requested)


func _on_windows_close_requested():
	save()
	get_tree().quit()


## Saves the progress in a folder with the save_name. If the save_name is
## empty - does nothing
func save() -> void:
	if save_name != "":
		var player : Player = Global.get_player()
		var objectives = player.objectives
		print("Saving game...")
		if !DirAccess.dir_exists_absolute(SAVES_FOLDER + save_name):
			DirAccess.make_dir_recursive_absolute(SAVES_FOLDER + save_name)
		
		# Player Stats
		config.load(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME)
		config.set_value("stats", "hp", player.hp)
		config.set_value("stats", "stamina", player.stamina)
		config.set_value("stats", "speed", player.speed)
		config.set_value("stats", "position", player.global_position)
		config.set_value("stats", "respawn_point", player.respawn_point)
		config.set_value("stats", "hunger", player.hunger_and_thirst.hunger)
		config.set_value("stats", "thirst", player.hunger_and_thirst.thirst)
		config.set_value("inventory", "inventory", player.inventory.items)
		config.set_value("inventory", "armor", player.inventory.armor)
		config.set_value("inventory", "backpack_item", player.inventory.backpack_item)
		config.set_value("inventory", "backpack", player.inventory.backpack.items)
		config.set_value("objectives", "current_objective", objectives.current_objective)
		config.set_value("other", "playtime", get_node("PlaytimeCounter").playtime)
		
		config.save(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME)
		
		# World
		var world_file = FileAccess.open(SAVES_FOLDER + save_name + "/" + WORLD_FILE_NAME, FileAccess.WRITE)
		var world = {
			"time_of_day": "",
			"time_till_time_change": null,
			"Objects":[]
		}
		
		# Time of day
		var day_night_cycle = get_tree().current_scene.find_child("DayNightCycle")
		if day_night_cycle.is_night:
			world.time_of_day = "night"
		else:
			world.time_of_day = "day"
		world.time_till_time_change = day_night_cycle.get_node("Timer").time_left
		
		# Objects
		for node in get_tree().get_nodes_in_group("Persistant"):
			var object = {
				"scene" = node.scene_file_path,
				"position" = [node.global_position.x, node.global_position.y],
				"data" = null
			}
			if node.has_method("get_save_data"):
				object.data = node.get_save_data()
			world.Objects.append(object)
		world_file.store_string(JSON.stringify(world, "\t"))
		world_file.close()
		
		print("Progress Saved")


## Deletes a save
func delete(save_name_to_delete : String) -> void:
	DirAccess.remove_absolute(SAVES_FOLDER + save_name_to_delete + "/" + PLAYER_STATS_FILE_NAME)
	DirAccess.remove_absolute(SAVES_FOLDER + save_name_to_delete + "/" + WORLD_FILE_NAME)
	DirAccess.remove_absolute(SAVES_FOLDER + save_name_to_delete)


## Gets all the saves inside the SAVES_FOLDER
func get_saves() -> PackedStringArray:
	return DirAccess.get_directories_at(SAVES_FOLDER)


## Checks whether or not a save with the save_name already exists
func has_save() -> bool:
	return DirAccess.dir_exists_absolute(SAVES_FOLDER + save_name)


## Checks whether or not a specific save exists
func has_save_with_name(_save_name : String) -> bool:
	return DirAccess.dir_exists_absolute(SAVES_FOLDER + _save_name)


## Gets the playtime of a specific save
func get_playtime(_save_name : String) -> float:
	if DirAccess.dir_exists_absolute(SAVES_FOLDER + _save_name):
		config.load(SAVES_FOLDER + _save_name + "/" + PLAYER_STATS_FILE_NAME)
		if config.has_section("other"):
			return config.get_value("other", "playtime", 0)
	return 0


## Loads a save with the save_name
func load_save() -> void:
	var player : Player = Global.get_player()
	var objectives = player.objectives
	if !DirAccess.dir_exists_absolute(SAVES_FOLDER + save_name):
		DirAccess.make_dir_recursive_absolute(SAVES_FOLDER + save_name)
	
	# Player Stats
	if config.load(SAVES_FOLDER + save_name + "/" + PLAYER_STATS_FILE_NAME) == OK:
		player.set_hp(config.get_value("stats", "hp", player.max_hp)) 
		player.stamina = config.get_value("stats", "stamina", player.max_stamina)
		player.speed = config.get_value("stats", "speed", player.base_speed)
		player.global_position = config.get_value("stats", "position", player.global_position)
		player.respawn_point = config.get_value("stats", "respawn_point", Vector2(5176, 2016))
		player.hunger_and_thirst.set_hunger(config.get_value("stats", "hunger", 0))
		player.hunger_and_thirst.set_thirst(config.get_value("stats", "thirst", 0))
		if config.has_section_key("inventory", "inventory"):
			player.inventory.set_items(config.get_value("inventory", "inventory"))
		else:
			player.inventory.set_items([])
		if config.has_section_key("inventory", "armor"):
			player.inventory.set_armor(config.get_value("inventory", "armor", null))
		if config.has_section_key("inventory", "backpack_item"):
			player.inventory.set_backpack(config.get_value("inventory", "backpack_item", null))
		if config.has_section_key("inventory", "backpack"):
			player.inventory.backpack.set_items(config.get_value("inventory", "backpack"))
		else:
			player.inventory.backpack.set_items([])
		if config.has_section("objectives"):
			objectives.set_objective(config.get_value("objectives", "current_objective", "movement"))
		if config.has_section("other"):
			get_node("PlaytimeCounter").start(config.get_value("other", "playtime", 0))
		else:
			get_node("PlaytimeCounter").start()
	
	# World
	var save_file = FileAccess.open(SAVES_FOLDER + save_name + "/" + WORLD_FILE_NAME, FileAccess.READ)
	var world = JSON.parse_string(save_file.get_as_text())
	
	# Time of Day
	var day_night_cycle = get_tree().current_scene.find_child("DayNightCycle")
	if world.time_of_day == "night":
		if world.time_till_time_change != null:
			day_night_cycle.set_to_night(true, world.time_till_time_change)
		else:
			day_night_cycle.set_to_night(true)
	else:
		if world.time_till_time_change != null:
			day_night_cycle.set_to_day(true, world.time_till_time_change)
		else:
			day_night_cycle.set_to_day(true)
	
	
	if world.Objects != null:
		for node in get_tree().get_nodes_in_group("Persistant"):
			node.queue_free()
		for i in range(world.Objects.size()):
			if world.Objects[i].scene != "":
				var node = load(world.Objects[i].scene).instantiate()
				node.global_position.x = world.Objects[i].position[0]
				node.global_position.y = world.Objects[i].position[1]
				if world.Objects[i].data != null:
					node.load_save_data(world.Objects[i].data)
				get_tree().current_scene.call_deferred("add_child", node)
