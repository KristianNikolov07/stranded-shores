extends Projectile

const TREE_SCENE = preload("res://Scenes/Structures/tree.tscn")

func plant(pos : Vector2):
	var tree = TREE_SCENE.instantiate()
	tree.global_position = pos
	get_tree().current_scene.call_deferred("add_child", tree)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	plant(global_position)
	if body is Player:
		body.damage(damage)


func _on_target_reached() -> void:
	plant(target)
