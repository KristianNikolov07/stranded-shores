extends StaticBody2D

const TREE_BOSS_SCENE = preload("res://Scenes/Entities/Bosses/TreeBoss/tree_boss.tscn")

func interact(_player : Player) -> void:
	# Objective
	Global.get_player().objectives.complete_objective("explore")
	var tree_boss = TREE_BOSS_SCENE.instantiate()
	tree_boss.global_position = global_position
	get_tree().current_scene.add_child(tree_boss)
	disable()


func enable() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT


func disable() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
