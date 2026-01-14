extends Area2D

signal hit

@export var damage = 1

var is_used = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("Attack"):
		stop_using()


func use() -> void:
	look_at(get_global_mouse_position())
	if $Cooldown.is_stopped():
		$CollisionShape2D.disabled = false
		is_used = true


func stop_using() -> void:
	$CollisionShape2D.disabled = true
	is_used = false


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(damage)
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		$Cooldown.start()


func _on_cooldown_timeout() -> void:
	if is_used:
		$CollisionShape2D.disabled = false
		$Cooldown.start()
