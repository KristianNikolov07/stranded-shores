class_name Enemy
extends Entity

@export var contact_damage : int
@export var activate_distance : float

func _ready() -> void:
	if $ContactDamage != null:
		$ContactDamage.body_entered.connect(_contact_damage_on_body_entered)


func _physics_process(_delta) -> void:
	move_toward_to_player()


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
