extends Structure

const CHANCE_TO_BE_ABLE_TO_GROW_APPLES = 25
const CHANCE_TO_SPAWN_WITH_APPLES = 5
const MIN_APPLE_GROW_SECS = 60
const MAX_APPLE_GROW_SECS = 180

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


func damage(dmg : int) -> void:
	super.damage(dmg)
	can_grow_apples = false
	has_apples = false


func grow_apples() -> void:
	if can_grow_apples:
		has_apples = true
		$Top.texture = apple_tree_texture


func remove_apples() -> void:
	has_apples = false
	$Top.texture = tree_texture


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
	if data.has("can_grow_apples"):
		can_grow_apples = data.can_grow_apples
	if data.has("has_apples"):
		if data.has_apples:
			grow_apples()
		else:
			remove_apples()
