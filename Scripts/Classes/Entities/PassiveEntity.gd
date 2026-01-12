class_name PassiveEntity
extends Entity

@export var max_target_distance : float = 100
@export var min_retarget_time : float = 0.5
@export var max_retarget_time : float = 1
@export var min_distance_before_retarget = 1

var target : Vector2

func _ready() -> void:
	retarget()


func neads_to_retarget() -> bool:
	if global_position.distance_to(target) <= min_distance_before_retarget:
		return true
		
	for raycast : RayCast2D in $CollisionCheck.get_children():
		if raycast.is_colliding():
			return true
			
	return false


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


func retarget() -> void:
	target.x = global_position.x + randf_range(-max_target_distance, max_target_distance)
	target.y = global_position.y + randf_range(-max_target_distance, max_target_distance)
	$CollisionCheck.look_at(target)
