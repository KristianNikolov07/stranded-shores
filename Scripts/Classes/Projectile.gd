class_name Projectile
extends Area2D

signal target_reached

@export var target : Vector2
@export var continue_after_target = true
@export var speed = 5
@export var damage = 0
@export var can_damage_structures = false

var direction : Vector2
var projectile_owner : Node

func _ready() -> void:
	if body_entered.is_connected(_on_body_entered) == false:
		body_entered.connect(_on_body_entered)
	direction = global_position.direction_to(target)
	look_at(target)


func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	if continue_after_target == false:
		if global_position.distance_to(target) <= 1:
			target_reached.emit()
			queue_free()


func _on_body_entered(body : Node2D) -> void:
	if body != projectile_owner:
		if body.has_method("damage"):
			if can_damage_structures or body is not Structure:
				body.damage(damage)
		queue_free()
