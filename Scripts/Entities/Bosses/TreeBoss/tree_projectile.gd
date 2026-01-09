extends Area2D

const TREE_SCENE = preload("res://Scenes/Structures/tree.tscn")

@export var speed : int
@export var damage : int

var target : Vector2

func _physics_process(delta: float) -> void:
	look_at(target)
	var velocity = global_position.direction_to(target) * speed
	global_position += velocity * delta * speed
	if global_position.distance_to(target) <= 1:
		plant(global_position)


func plant(pos : Vector2):
	var tree = TREE_SCENE.instantiate()
	tree.global_position = pos
	get_tree().current_scene.call_deferred("add_child", tree)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	plant(global_position)
	if body is Player:
		body.damage(damage)
