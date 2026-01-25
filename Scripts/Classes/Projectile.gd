class_name Projectile
extends Area2D

## The base class for the projectils

## Emitted when the projectile reaches its target. Only emits if continue_ater_target is false
signal target_reached

## The position the projectile is fling toward
@export var target : Vector2
## Whether or not the projectile can continue fling after the target position is reached
@export var continue_after_target = true
## The speed of the projectile
@export var speed = 5
## The amount of damage the projectile deals the entities of structure when it hits them
@export var damage = 0
## Whether or not the projectile can damage structures
@export var can_damage_structures = false

## The direction the projectile moves towards
var direction : Vector2
## The character body that the projectile was shot by
var projectile_owner : CharacterBody2D

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
