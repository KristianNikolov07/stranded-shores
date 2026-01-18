extends AnimationTree

@onready var player : Player = get_parent()
@onready var sprite : Sprite2D = get_node("../Sprite2D")

func _process(_delta: float) -> void:
	# Animations
	if player.velocity == Vector2.ZERO:
		set("parameters/conditions/Idle", true)
		set("parameters/conditions/Walking", false)
		set("parameters/conditions/Running", false)
	elif player.is_running == false or player.stamina <= 0:
		set("parameters/conditions/Idle", false)
		set("parameters/conditions/Walking", true)
		set("parameters/conditions/Running", false)
	else:
		set("parameters/conditions/Idle", false)
		set("parameters/conditions/Walking", false)
		set("parameters/conditions/Running", true)
	
	# Rotation
	if player.velocity.x < 0:
		sprite.flip_h = true
	elif player.velocity.x > 0:
		sprite.flip_h = false
