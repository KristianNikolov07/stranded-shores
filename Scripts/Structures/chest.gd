extends Structure

@onready var player : Player = Global.get_player()

func interact(_player : Player):
	open()


func open() -> void:
	if player.can_move:
		$CanvasLayer/Storage.open()
		player.can_move = false
		player.inventory.opened_storage = $CanvasLayer/Storage


func destroy() -> void:
	for item : Item in $CanvasLayer/Storage.items:
		if item != null:
			var dropped_item = DROPPED_ITEM_SCENE.instantiate()
			dropped_item.global_position = global_position
			dropped_item.item = item
			dropped_item.item.amount = item.amount
			get_tree().current_scene.add_child(dropped_item)
	super.destroy()


func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	var contents : Array
	
	for item : Item in $CanvasLayer/Storage.items:
		if item != null:
			var save = {
				"path": item.item_path,
				"data": item.get_save_data()
			}
			contents.append(save)
			
	var new_data = {
		"contents":contents
	}
	data.merge(new_data)
	return data


func load_save_data(data : Dictionary) -> void:
	if data.has("contents"):
		for saved_item in data.contents:
			if saved_item != null:
				var item : Item = load(saved_item.path).duplicate()
				item.load_save_data(saved_item.data)
				$CanvasLayer/Storage.add_item(item)
	super.load_save_data(data)
