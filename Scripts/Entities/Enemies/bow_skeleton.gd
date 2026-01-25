extends Enemy

## The logit for the skeletons that use bows

const ARROW_SCENE = preload("res://Scenes/Objects/arrow.tscn")

## The minimum distance the skeleton need to be from the player in order to start shooting 
@export var shooting_range : float = 100
## The minimum amount of time that the skeleton needs to wait for before shooting an arrow
@export var min_shooting_cooldown : float = 0.5
## The maximum amount of time that the skeleton can wait for before shooting an arrow
@export var max_shooting_cooldown : float = 1

func _physics_process(_delta) -> void:
	var player : Player = Global.get_player()
	$Bow.look_at(player.global_position)
	if global_position.distance_to(player.global_position) > shooting_range:
		move_toward_to_player()
	elif $ShootingTimer.is_stopped():
		$ShootingTimer.start(randf_range(min_shooting_cooldown, max_shooting_cooldown))


## Shoots an arrow towards the player
func shoot() -> void:
	var arrow : Projectile = ARROW_SCENE.instantiate()
	arrow.projectile_owner = self
	arrow.global_position = $Bow/ShootingPoint.global_position
	arrow.target = Global.get_player().global_position
	get_tree().current_scene.add_child(arrow)


func _on_shooting_timer_timeout() -> void:
	shoot()
