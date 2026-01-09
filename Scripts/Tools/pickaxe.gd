extends Area2D

signal hit

@export var damage = 1

var is_used = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("Attack"):
		$CollisionShape2D.disabled = true
		is_used = false
		print("stopped using")


func use() -> void:
	look_at(get_global_mouse_position())
	$CollisionShape2D.disabled = false
	is_used = true


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(damage)
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		$Cooldown.start()
		print("hit")


func _on_cooldown_timeout() -> void:
	$CollisionShape2D.disabled = false
	print("timer")
	if is_used:
		$Cooldown.start()
