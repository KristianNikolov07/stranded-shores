extends Projectile

## The logic for the tree projectiles the the Tree Boss shoots

const TREE_SCENE = preload("res://Scenes/Structures/tree.tscn")

## Plants the tree
func plant(pos : Vector2):
	var tree = TREE_SCENE.instantiate()
	tree.global_position = pos
	get_tree().current_scene.call_deferred("add_child", tree)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damage(damage)
	elif body is Structure:
		body.destroy()


func _on_target_reached() -> void:
	plant(target)
