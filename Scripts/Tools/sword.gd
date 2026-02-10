extends Area2D

signal hit

@export var damage = 10

func _ready() -> void:
	hide()
	$CollisionShape2D.disabled = true


func _process(_delta: float) -> void:
	if visible:
		if Global.is_using_controller == false:
			look_at(get_global_mouse_position())
		else:
			look_at(Input.get_vector("ControllerRightJoystickLeft", "ControllerRightJoystickRight", "ControllerRightJoystickUp", "ControllerRightJoystickDown"))


func _input(event: InputEvent) -> void:
	if event.is_action_released("Attack") or Global.is_using_controller and Input.get_vector("ControllerRightJoystickLeft", "ControllerRightJoystickRight", "ControllerRightJoystickUp", "ControllerRightJoystickDown") == Vector2.ZERO:
		stop_using()


func use() -> void:
	show()
	$CollisionShape2D.disabled = false


func stop_using() -> void:
	hide()
	$CollisionShape2D.set_deferred("disabled", true)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(damage)
		hit.emit()
		$AudioStreamPlayer2D.play()
