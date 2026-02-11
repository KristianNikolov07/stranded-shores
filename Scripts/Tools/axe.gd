extends Node2D

signal hit

@export var damage = 10

func _ready() -> void:
	hide()


func use() -> void:
	show()
	var aim_pos : Vector2
	
	if Global.is_using_controller == false:
		aim_pos = get_global_mouse_position()
	
	# Controller
	else:
		aim_pos = global_position + Global.get_player().direction
	
	look_at(aim_pos)
	$Area2D/CollisionShape2D.disabled = false
	if aim_pos.x < global_position.x:
		$Area2D/AnimationPlayer.play_backwards("hit")
		$Area2D/Sprite2D.flip_v = true
		$Area2D/Sprite2D.rotation_degrees = -45
	else:
		$Area2D/AnimationPlayer.play("hit")
		$Area2D/Sprite2D.flip_v = false
		$Area2D/Sprite2D.rotation_degrees = 45
		
	await $Area2D/AnimationPlayer.animation_finished
	$Area2D/CollisionShape2D.disabled = true
	hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(damage)
		hit.emit()
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		hide()
