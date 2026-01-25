extends StaticBody2D

## Handles the logic for tree boss spawner

const TREE_BOSS_SCENE = preload("res://Scenes/Entities/Bosses/TreeBoss/tree_boss.tscn")

## Called when that player interactes with the spawner
func interact(_player : Player) -> void:
	# Objective
	Global.get_player().objectives.complete_objective("explore")
	var tree_boss = TREE_BOSS_SCENE.instantiate()
	tree_boss.global_position = global_position
	get_tree().current_scene.add_child(tree_boss)
	disable()


## Shows and enables the spawner
func enable() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT


## Hides and Disables the spawner
func disable() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
