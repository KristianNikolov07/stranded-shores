extends Control

@export var indicator_pulse_speed = 1
@export var map_capture_range = 10

## -1 if fading out, 1 if fading in
var indicator_pulse_direction = -1
var tilemap_tile_images = {}

@onready var player : Player = get_node("../../")
@onready var tilemap : TileMapLayer = get_tree().get_first_node_in_group("Tilemap")
@onready var map_image : Image = $MapTexture.texture.get_image()
@onready var size_diff = Vector2(Global.get_world_size() / map_image.get_width(), Global.get_world_size() / map_image.get_height())

func _ready() -> void:
	hide()
	$MapViewport.world_2d = get_viewport().world_2d
	load_save()
	fetch_tilemap_tile_images()


func _physics_process(delta: float) -> void:
	if player.velocity != Vector2.ZERO:
		$MapTexture.self_modulate.a = 0.25
		move_player_indicator(player.global_position)
		capture()
	else:
		$MapTexture.self_modulate.a = 1
	
	if visible:
		
		$MapTexture/PlayerIndicator.self_modulate.a += indicator_pulse_direction * delta * indicator_pulse_speed
		print($MapTexture/PlayerIndicator.self_modulate.a)
		
		if $MapTexture/PlayerIndicator.self_modulate.a >= 1:
			indicator_pulse_direction = -1
		elif $MapTexture/PlayerIndicator.self_modulate.a <= 0:
			indicator_pulse_direction = 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OPEN_MAP"):
		move_player_indicator(player.global_position)
		visible = !visible
		capture()
	elif event.is_action_pressed("esc") and visible:
		hide()
		accept_event()


func fetch_tilemap_tile_images() -> void:
	var tile_set_source = tilemap.tile_set.get_source(1) as TileSetAtlasSource
	var atlas_image : Image = tile_set_source.texture.get_image()
	var world_tile_size = float(Global.TILE_SIZE * Global.TILEMAP_SCALE)
	var map_tile_size = Vector2i((Vector2(world_tile_size, world_tile_size) / size_diff))
	
	for i in tile_set_source.get_tiles_count():
		var coords : Vector2i = tile_set_source.get_tile_id(i)
		var rect : Rect2i = tile_set_source.get_tile_texture_region(coords)
		var image : Image = atlas_image.get_region(rect)
		image.resize(map_tile_size.x, map_tile_size.y, Image.INTERPOLATE_NEAREST)
		tilemap_tile_images.set(coords, image)
	
	
func set_player_indicator_color(color : Color) -> void:
	$MapTexture/PlayerIndicator.self_modulate = color


func move_player_indicator(player_position : Vector2) -> void:
	var scale_div: float = float(Global.TILEMAP_SCALE * Global.TILEMAP_SIZE * Global.TILE_SIZE) / $MapTexture.size.x
	$MapTexture/PlayerIndicator.position = player_position / scale_div


func capture() -> void:
	var center_pos = Vector2i(Global.global_coords_to_tilemap_coords(player.global_position))
	var start_pos = center_pos - Vector2i(map_capture_range, map_capture_range)
	var end_pos = center_pos + Vector2i(map_capture_range, map_capture_range)
	
	for x in range(start_pos.x, end_pos.x):
		for y in range(start_pos.y, end_pos.y):
			var atlas_coords : Vector2i = tilemap.get_cell_atlas_coords(Vector2i(x, y))
			var tile_image : Image = tilemap_tile_images.get(atlas_coords)
			if tile_image != null:
				var world_pos : Vector2 = Global.tilemap_coords_to_global_coords(Vector2(x, y))
				var pos := Vector2i((world_pos / size_diff).round())
				
				map_image.blit_rect(tile_image, Rect2i(Vector2i.ZERO, tile_image.get_size()), pos)
	
	$MapTexture.texture = ImageTexture.create_from_image(map_image)


func save() -> void:
	var map : Image = $MapTexture.texture.get_image()
	map.save_png(SaveProgress.SAVES_FOLDER.path_join(SaveProgress.save_name).path_join("map.png"))


func load_save() -> void:
	var map : Image = Image.load_from_file(SaveProgress.SAVES_FOLDER.path_join(SaveProgress.save_name).path_join("map.png"))
	if map != null:
		$MapTexture.texture = ImageTexture.create_from_image(map)
