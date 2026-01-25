class_name Enemy
extends Entity

## The base class for the Enemies

## The damage the enemy dials on contact with the player
@export var contact_damage : int
## The distance the enemy starts targeting the player from
@export var activate_distance : float = 1000

func _ready() -> void:
	if $ContactDamage != null:
		$ContactDamage.body_entered.connect(_contact_damage_on_body_entered)


func _physics_process(_delta) -> void:
	move_toward_to_player()


## Moves the enemy towards the player
func move_toward_to_player() -> void:
	var player : Player = Global.get_player()
	if global_position.distance_to(player.global_position) < activate_distance:
		velocity = global_position.direction_to(player.global_position) * speed
		if velocity.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		move_and_slide()


func _contact_damage_on_body_entered(body) -> void:
	if body is Player:
		body.damage(contact_damage)
