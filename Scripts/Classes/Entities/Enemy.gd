class_name Enemy
extends Entity

@export var dmg : int
@export var activate_distance : float

func _ready() -> void:
	super._ready()
	if $ContactDamage != null:
		$ContactDamage.body_entered.connect(_contact_damage_on_body_entered)


func _physics_process(_delta) -> void:
	move_toward_to_player()


func move_toward_to_player() -> void:
	if global_position.distance_to(get_tree().get_first_node_in_group("Player").global_position) < activate_distance:
		velocity = global_position.direction_to(get_tree().get_first_node_in_group("Player").global_position) * speed
		move_and_slide()


func _contact_damage_on_body_entered(body) -> void:
	if body is Player:
		body.damage(dmg)
