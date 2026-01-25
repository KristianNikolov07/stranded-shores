extends Node

const TILE_SIZE = 16
const TILEMAP_SCALE = 4
const TILEMAP_SIZE = 256
const SETTINGS_FILE_PATH = "user://settings.ini"
const MODS_FOLDER = "user://mods"
const MODS_ENABLE_CHECK_FILE_NAME = "enabled"
const MODS_MANIFEST_FILE_NAME = "manifest.json"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ToggleFullscreen"):
		toggle_fullscreen()


func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func tilemap_coords_to_global_coords(tilemap_coords : Vector2) -> Vector2:
	@warning_ignore("integer_division")
	var x = tilemap_coords.x * TILE_SIZE * TILEMAP_SCALE + TILE_SIZE / 2
	@warning_ignore("integer_division")
	var y = tilemap_coords.y * TILE_SIZE * TILEMAP_SCALE + TILE_SIZE / 2
	return Vector2(x, y)


func global_coords_to_tilemap_coords(global_coords : Vector2) -> Vector2:
	@warning_ignore("narrowing_conversion")
	var x : int = global_coords.x / (TILE_SIZE * TILEMAP_SCALE)
	@warning_ignore("narrowing_conversion")
	var y : int = global_coords.y / (TILE_SIZE * TILEMAP_SCALE)
	return Vector2(x, y)


func get_player() -> Player:
	if get_tree().current_scene.has_node("Player"):
		var player : Player = get_tree().current_scene.find_child("Player")
		return player
	else:
		return null
