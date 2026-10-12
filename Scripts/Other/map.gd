extends Control

@export var indicator_pulse_speed = 1

## -1 if fading out, 1 if fading in
var indicator_pulse_direction = -1

@onready var player : Player = get_node("../../")


func _ready() -> void:
	hide()
	$MapViewport.world_2d = get_viewport().world_2d
	load_save()


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


func set_player_indicator_color(color : Color) -> void:
	$MapTexture/PlayerIndicator.self_modulate = color


func move_player_indicator(player_position : Vector2) -> void:
	var scale_div: float = float(Global.TILEMAP_SCALE * Global.TILEMAP_SIZE * Global.TILE_SIZE) / $MapTexture.size.x
	$MapTexture/PlayerIndicator.position = player_position / scale_div


func capture() -> void:
	$MapViewport/Camera2D.global_position = player.global_position
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	
	# Get images
	var map: Image = $MapTexture.texture.get_image()
	var map_viewport_image: Image = $MapViewport.get_texture().get_image()

	# Resize
	var map_image_size: Vector2i = map.get_size()
	var scale_div: float = float(Global.TILEMAP_SCALE * Global.TILEMAP_SIZE * Global.TILE_SIZE) / map_image_size.x
	var new_size := Vector2i(Vector2(map_viewport_image.get_size()) / scale_div)
	map_viewport_image.resize(new_size.x, new_size.y)

	# Calculate position
	var pos := Vector2i(player.global_position / scale_div) - new_size / 2
	
	map.blend_rect(map_viewport_image, Rect2i(Vector2i.ZERO, new_size), pos)
	$MapTexture.texture = ImageTexture.create_from_image(map)


func save() -> void:
	var map : Image = $MapTexture.texture.get_image()
	map.save_png(SaveProgress.SAVES_FOLDER.path_join(SaveProgress.save_name).path_join("map.png"))


func load_save() -> void:
	var map : Image = Image.load_from_file(SaveProgress.SAVES_FOLDER.path_join(SaveProgress.save_name).path_join("map.png"))
	if map != null:
		$MapTexture.texture = ImageTexture.create_from_image(map)
