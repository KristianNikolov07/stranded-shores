extends Node

const TILE_SIZE = 16
const TILEMAP_SCALE = 4
const TILEMAP_SIZE = 256
const SETTINGS_FILE_PATH = "user://settings.ini"
const MODS_FOLDER = "user://mods"
const MODS_ENABLE_CHECK_FILE_NAME = "enabled"

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
	var player : Player = get_tree().current_scene.find_child("Player")
	return player
