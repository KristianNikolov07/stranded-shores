extends TextureRect

## The global position of the structure in the world
@export var structure_pos : Vector2

var shown = true

@onready var resolution = get_viewport().get_visible_rect().size
@onready var player : Player = get_tree().get_first_node_in_group("Player")
@onready var camera : Camera2D = get_viewport().get_camera_2d()

func _process(_delta: float) -> void:
	print(resolution)
	var pos = resolution / 2 + (structure_pos - camera.global_position)
	# Hide if the object is inside the camera's view
	if pos.x > 0 - size.x / 2 and pos.x < resolution.x  - size.x / 2 and pos.y > 0 - size.x / 2 and pos.y < resolution.y  - size.x / 2:
		if $AnimationPlayer.is_playing() == false and shown:
			$AnimationPlayer.play("hide")
			shown = false
		return
	
	if $AnimationPlayer.is_playing() == false and shown == false:
		$AnimationPlayer.play_backwards("hide") 
		shown = true
	if pos.x < 0 - size.x / 2:
		pos.x = 0 - size.x / 2
	elif pos.x > resolution.x - size.x / 2:
		pos.x = resolution.x - size.x / 2
	
	if pos.y < 0 - size.x / 2:
		pos.y = 0 - size.x / 2
	elif pos.y > resolution.y - size.x / 2:
		pos.y = resolution.y - size.x / 2
	print(pos)
	global_position = pos
