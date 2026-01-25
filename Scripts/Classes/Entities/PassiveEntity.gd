class_name PassiveEntity
extends Entity

## The base class for the passive entities

## The maximum amount of distance the walking target can be from the entity
@export var max_target_distance : float = 100
## The minimum amount of time before the entity attempts the retarget
@export var min_retarget_time : float = 0.5
## The maximum amount of time before the entity attempts the retarget
@export var max_retarget_time : float = 1
## The minimum amount of distance the entity needs to be from the target in order the retarget
## before the retarget timer runs out
@export var min_distance_before_retarget = 1

## The position the entity attempts to reach
var target : Vector2

func _ready() -> void:
	retarget()


func _physics_process(_delta) -> void:
	if neads_to_retarget():
		retarget()
	else:
		velocity = global_position.direction_to(target) * speed
		if velocity.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		move_and_slide()


## Checks whether or not the entity needs to retarget
func neads_to_retarget() -> bool:
	if global_position.distance_to(target) <= min_distance_before_retarget:
		return true
		
	for raycast : RayCast2D in $CollisionCheck.get_children():
		if raycast.is_colliding():
			return true
			
	return false


## Changes the target
func retarget() -> void:
	target.x = global_position.x + randf_range(-max_target_distance, max_target_distance)
	target.y = global_position.y + randf_range(-max_target_distance, max_target_distance)
	$CollisionCheck.look_at(target)
