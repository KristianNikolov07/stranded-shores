extends Structure

const CHANCE_TO_BE_ABLE_TO_GROW_APPLES = 50
const CHANCE_TO_SPAWN_WITH_APPLES = 5
const MIN_APPLE_GROW_SECS = 10
const MAX_APPLE_GROW_SECS = 20

@export var tree_texture : Texture
@export var apple_tree_texture : Texture

var can_grow_apples = false
var has_apples = false

func _ready() -> void:
	if randi_range(1, 100) <= CHANCE_TO_BE_ABLE_TO_GROW_APPLES:
		can_grow_apples = true
		if randf_range(1, 100) <= CHANCE_TO_SPAWN_WITH_APPLES:
			grow_apples()
		else:
			$AppleTimer.start(randf_range(MIN_APPLE_GROW_SECS, MAX_APPLE_GROW_SECS))


func grow_apples() -> void:
	has_apples = true
	$Sprite2D.texture = apple_tree_texture


func remove_apples() -> void:
	has_apples = false
	$Sprite2D.texture = tree_texture


func _on_apple_timer_timeout() -> void:
	grow_apples()
	$AppleTimer.start(randf_range(MIN_APPLE_GROW_SECS, MAX_APPLE_GROW_SECS))


func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	var new_data = {
		"can_grow_apples": can_grow_apples,
		"has_apples": has_apples
	}
	data.merge(new_data)
	return data


func load_save_data(data : Dictionary) -> void:
	if data.can_grow_apples != null:
		can_grow_apples = data.can_grow_apples
	if data.has_apples != null:
		if data.has_apples:
			grow_apples()
		else:
			remove_apples()
