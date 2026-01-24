extends Area2D

@export var item_stack : ItemStack
@export var can_despawn = true

func _ready() -> void:
	$ItemTexture.texture = item_stack.item.texture
	if can_despawn:
		$DespawnTimer.start()


func interact(player : CharacterBody2D) -> void:
	if player.inventory.add_item(item_stack):
		queue_free()
	pass


func get_save_data() -> Dictionary:
	var data = {
		"item": {
			"path": item_stack.item.get_path(),
			"data": item_stack.get_save_data()
		},
		"can_despawn": can_despawn,
		"despawn_time_left": $DespawnTimer.time_left
	}
	return data


func load_save_data(data : Dictionary) -> void:
	if data.item.path != null:
		item_stack = ItemStack.new()
		item_stack.item = load(data.item.path)
		
		item_stack.load_save_data(data.item.data)
		can_despawn = data.can_despawn
		if can_despawn:
			$DespawnTimer.wait_time = data.despawn_time_left


func _on_despawn_timer_timeout() -> void:
	queue_free()
