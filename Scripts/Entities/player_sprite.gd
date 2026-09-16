extends Node2D

const DEFAULT_HAIR_COLOR = Color("222034")
const DEFAULT_SKIN_COLOR = Color("eec39a")
const DEFAULT_SHIRT_COLOR = Color("306082")

func _ready() -> void:
	set_all_to_default()


func set_hair_color(color : Color) -> void:
	$Head/Hair.self_modulate = color


func set_skin_color(color : Color) -> void:
	$Head/Skin.self_modulate = color


func set_shirt_color(color : Color) -> void:
	$Body/Shirt.self_modulate = color


func set_all_to_default() -> void:
	$Head/Hair.self_modulate = DEFAULT_HAIR_COLOR
	$Head/Skin.self_modulate = DEFAULT_SKIN_COLOR
	$Body/Shirt.self_modulate = DEFAULT_SHIRT_COLOR


func start_idle() -> void:
	$AnimationPlayer.play("idle")


func start_walking() -> void:
	$AnimationPlayer.play("walking")


func start_running() -> void:
	$AnimationPlayer.play("running")
