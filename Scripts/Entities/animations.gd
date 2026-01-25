extends AnimationTree

## A script responsible for controlling the AnimationTree of the entities

func _process(_delta: float) -> void:
	if get_parent().velocity == Vector2.ZERO:
		set("parameters/conditions/Idle", true)
		set("parameters/conditions/Walking", false)
	else:
		set("parameters/conditions/Idle", false)
		set("parameters/conditions/Walking", true)
