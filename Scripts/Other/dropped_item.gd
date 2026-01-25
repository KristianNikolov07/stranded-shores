extends Area2D

## The script for the dropped items

## The dropped item
@export var item : Item
## Whether or not the item despawns after a surtain time
@export var can_despawn = true

func _ready() -> void:
	$ItemTexture.texture = item.texture
	if can_despawn:
		$DespawnTimer.start()


## Called when the player interacts with the item
func interact(player : CharacterBody2D) -> void:
	if player.inventory.add_item(item):
		queue_free()


func get_save_data() -> Dictionary:
	var data = {
		"item": {
			"path": item.item_path,
			"data": item.get_save_data()
		},
		"can_despawn": can_despawn,
		"despawn_time_left": $DespawnTimer.time_left
	}
	return data


func load_save_data(data : Dictionary) -> void:
	if data.item.path != null:
		item = load(data.item.path).duplicate()
		
		item.load_save_data(data.item.data)
		can_despawn = data.can_despawn
		if can_despawn:
			$DespawnTimer.wait_time = data.despawn_time_left


func _on_despawn_timer_timeout() -> void:
	queue_free()
