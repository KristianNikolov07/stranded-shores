extends Structure

@onready var player : Player = get_tree().get_first_node_in_group("Player")

func open() -> void:
	if player.can_move:
		$CanvasLayer/Storage.open()
		player.can_move = false
		player.inventory.opened_storage = $CanvasLayer/Storage


func destroy() -> void:
	for item : Item in $CanvasLayer/Storage.items:
		if item != null:
			var dropped_item = dropped_item_scene.instantiate()
			dropped_item.global_position = global_position
			dropped_item.item = item
			dropped_item.item.amount = item.amount
			get_tree().current_scene.add_child(dropped_item)
	super.destroy()
