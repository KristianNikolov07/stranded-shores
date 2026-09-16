extends Control

signal closed

const WORLD_OPTION_SCENE = preload("res://Scenes/Menu/world_option.tscn")

var worlds = [WorldInfo]

func _ready() -> void:
	hide()
	get_worlds()
	instantiate_worlds()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_back_pressed()
			accept_event()


func get_worlds() -> void:
	worlds = SaveProgress.get_saves()


func instantiate_worlds() -> void:
	if worlds.is_empty():
		return
	
	var most_recent : WorldInfo = null
	for world in worlds:
		if most_recent == null or int(most_recent.last_played_timestamp) < int(world.last_played_timestamp):
			most_recent = world
	
	var world_option_node = WORLD_OPTION_SCENE.instantiate()
	world_option_node.world_info = most_recent
	%Worlds.add_child(world_option_node)
	
	worlds.erase(most_recent)
	instantiate_worlds()


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func _on_create_new_world_pressed() -> void:
	%CreateNewWorldMenu.show()
