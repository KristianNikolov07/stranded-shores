extends Enemy

## The main logic of the Tree Boss

## The attack states the boss can be in
enum State{
	SHOOTING,
	WALKING
}

const TREE_PROJECTILES_SCENE = preload("res://Scenes/Entities/Bosses/TreeBoss/tree_projectile.tscn")
## The minimum amount of time the boss has to wait for before changing its attack state
const MIN_CHANGE_STATE_TIME = 10
## The maximum amount of time the boss can wait for before changing its attack state
const MAX_CHANGE_STATE_TIME = 30
## The minimum amount of time the boss has to wait for before shooting a tree
const MIN_CHANGE_SHOOT_TIME = 1
## The maximum amount of time the boss can wait for before shooting a tree
const MAX_CHANGE_SHOOT_TIME = 5

## The attack state the boss is currently in
var current_state = State.WALKING

func _ready() -> void:
	super._ready()
	$ChangeStateTimer.start(randf_range(MIN_CHANGE_STATE_TIME, MAX_CHANGE_STATE_TIME))
	$CanvasLayer/Bossbar.max_value = max_hp
	$CanvasLayer/Bossbar.value = max_hp


func _process(_delta: float) -> void:
	var player : Player = Global.get_player()
	if player.global_position.distance_to(global_position) > despawn_distance:
		get_tree().current_scene.find_child("TreeBossSpawn").enable()
		queue_free()


func _physics_process(_delta) -> void:
	if current_state == State.WALKING:
		move_toward_to_player()


func damage(_dmg : int) -> void:
	super.damage(_dmg)
	$CanvasLayer/Bossbar.value = hp


func kill() -> void:
	# Objective
	Global.get_player().objectives.complete_objective("tree boss")
	
	super.kill()


func _on_change_state_timer_timeout() -> void:
	if current_state == State.SHOOTING:
		change_state(State.WALKING)
	else:
		change_state(State.SHOOTING)
	$ChangeStateTimer.start(randf_range(MIN_CHANGE_STATE_TIME, MAX_CHANGE_STATE_TIME))


## Changes the attack state of the boss
func change_state(state : State) -> void:
	current_state = state
	if state == State.SHOOTING:
		$ShootTimer.start(randf_range(MIN_CHANGE_SHOOT_TIME, MAX_CHANGE_SHOOT_TIME))
	else:
		$ShootTimer.stop()


## Shoots a tree toward a target
func shoot_tree(target : Vector2):
	$ShootFrom.look_at(target)
	var tree = TREE_PROJECTILES_SCENE.instantiate()
	tree.global_position = $ShootFrom/Marker2D.global_position
	tree.target = target
	get_tree().current_scene.add_child(tree)


func _on_shoot_timer_timeout() -> void:
	shoot_tree(Global.get_player().global_position)
	$ShootTimer.start(randf_range(MIN_CHANGE_SHOOT_TIME, MAX_CHANGE_SHOOT_TIME))


func _on_structure_destory_body_entered(body: Node2D) -> void:
	if body.has_method("destroy"):
		body.destroy()
