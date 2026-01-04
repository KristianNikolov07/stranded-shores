extends CanvasLayer

var test_entity_scene = preload("res://Scenes/Entity/test_entity.tscn")
var test_enemy_scene = preload("res://Scenes/Entity/Enemies/test_enemy.tscn")

@onready var player : Player = get_node("../Player")

func _ready() -> void:
	$Debug.hide()


func _input(event: InputEvent) -> void:
	if "debug" in OS.get_cmdline_args():
		if event.is_action_pressed("Debug"):
			$Debug.visible = !$Debug.visible


func list_items() -> void:
	for i in range(player.inventory.items.size()):
		print("Item " + str(i) + ":")
		if player.inventory.items[i] == null:
			print("null")
		else:
			print("Name: " + player.inventory.items[i].item_name)
			print("Amount: " + str(player.inventory.items[i].amount) + "/" + str(player.inventory.items[i].max_amount))


func _on_add_test_item_pressed() -> void:
	var test_item = load("res://Resources/Items/test_item.tres")
	if player.inventory.add_item(test_item.duplicate()) == true:
		print("Successfully added a test item")
	else:
		print("Unable to add a test item")


func _on_remove_test_item_pressed() -> void:
	if player.inventory.remove_item("test item") == true:
		print("Successfully removed a test item")
	else:
		print("Unable to remove a test item")


func _on_add_test_consumable_pressed() -> void:
	var test_item = load("res://Resources/Items/Consumables/test_consumable.tres")
	if player.inventory.add_item(test_item.duplicate()) == true:
		print("Successfully added a test consumable")
	else:
		print("Unable to add a test consumable")


func _on_add_basic_sword_pressed() -> void:
	var sword = load("res://Resources/Items/Tools/test_weapon.tres")
	if player.inventory.add_item(sword.duplicate()) == true:
		print("Successfully added a test sword")
	else:
		print("Unable to add a test sword")


func _on_damage_player_pressed() -> void:
	player.damage(10)


func _on_heal_player_pressed() -> void:
	player.heal(10)


func _on_save_pressed() -> void:
	SaveProgress.save_name = "Test"
	SaveProgress.save()


func _on_load_pressed() -> void:
	SaveProgress.save_name = "Test"
	SaveProgress.load()


func _on_spawn_test_entity_pressed() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	var entity : Entity = test_entity_scene.instantiate()
	entity.global_position = player.global_position
	player.get_parent().add_child(entity)


func _on_spawn_test_enemy_pressed() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	var enemy : Enemy = test_enemy_scene.instantiate()
	enemy.global_position = player.global_position
	player.get_parent().add_child(enemy)


func _on_time_change_pressed() -> void:
	$"../DayNightCycle"._on_timer_timeout()
