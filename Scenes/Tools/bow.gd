extends Node2D

signal hit

const ARROW_SCENE = preload("res://Scenes/Objects/arrow.tscn")

@export var damage = 20

func _process(_delta: float) -> void:
	if Global.is_using_controller == false:
		look_at(get_global_mouse_position())
		
	# Controller
	else:
		var aim_joystick_dir = Input.get_vector("ControllerRightJoystickLeft", "ControllerRightJoystickRight", "ControllerRightJoystickUp", "ControllerRightJoystickDown")
		if aim_joystick_dir != Vector2.ZERO:
			look_at(global_position + aim_joystick_dir)


func use() -> void:
	var player : Player = Global.get_player()
	if player.inventory.has_item("Arrow"):
		var arrow = ARROW_SCENE.instantiate()
		arrow.global_position = $ShootPoint.global_position
		arrow.damage = damage
		arrow.projectile_owner = player
		arrow.target = get_global_mouse_position()
		get_tree().current_scene.add_child(arrow)
		hit.emit()
		player.inventory.remove_item("Arrow")
