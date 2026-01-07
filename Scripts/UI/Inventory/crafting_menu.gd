extends Control

var crafting_recipe_scene = preload("res://Scenes/UI/Inventory/crafting_recipe_ui.tscn")
var dropped_item_scene = preload("res://Scenes/Objects/dropped_item.tscn")
var selected_recipe : Recipe
var is_crafting_table : bool = false
var selected_tool : Recipe.CraftingTool = Recipe.CraftingTool.NONE

@onready var player : Player = get_node("../../")

func _ready() -> void:
	hide()
	load_recipes()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenCraftingUI"):
		if visible == false:
			open_menu()
		else:
			player.can_move = true
			hide()
			accept_event()
	elif event.is_action_pressed("esc"):
		if visible:
			player.can_move = true
			hide()
			accept_event()


func open_menu(_is_crafting_table = false) -> void:
	# Objective
	get_tree().get_first_node_in_group("Objectives").complete_objective("open crafting menu")
	
	
	if player.can_move:
		player.can_move = false
		selected_recipe = null
		is_crafting_table = _is_crafting_table
		
		if is_crafting_table:
			%Tools.show()
		else:
			%Tools.hide()
			
		update_ui()
		show()


func load_recipes() -> void:
	for file in DirAccess.get_files_at("res://Resources/Recipes"):
		var file_name = file.replace(".remap", "")
		var recipe = load("res://Resources/Recipes/" + file_name)
		var crafting_recipe_ui = crafting_recipe_scene.instantiate()
		crafting_recipe_ui.recipe = recipe
		%Recipes.add_child(crafting_recipe_ui)
		crafting_recipe_ui.recipe_selected.connect(select_recipe)


func craft(recipe : Recipe) -> void:
	if player.inventory.has_item(recipe.item1.item_name, recipe.item1_amount) and player.inventory.has_item(recipe.item2.item_name, recipe.item2_amount):
		player.inventory.remove_item(recipe.item1.item_name, recipe.item1_amount)
		player.inventory.remove_item(recipe.item2.item_name, recipe.item2_amount)
		
		# Basic Axe Objective
		if recipe.result.item_name == "Basic Axe":
			get_tree().get_first_node_in_group("Objectives").complete_objective("craft basic axe")
		
		if !player.inventory.add_item(recipe.result.duplicate()):
			var dropped_item = dropped_item_scene.instantiate()
			dropped_item.item = recipe.result
			dropped_item.global_position = player.global_position
			get_tree().current_scene.add_child(dropped_item)
		update_ui()


func select_tool(tool : Recipe.CraftingTool) -> void:
	selected_tool = tool
	update_ui()


func select_recipe(recipe : Recipe) -> void:
	selected_recipe = recipe
	update_ui()


func update_ui() -> void:
	if selected_recipe == null:
		%CraftingSlot1.set_item(null)
		%CraftingSlot2.set_item(null)
		%Result.set_item(null)
		%CraftButton.disabled = true
	else:
		%CraftingSlot1.set_item(selected_recipe.item1, selected_recipe.item1_amount, player.inventory.has_item(selected_recipe.item1.item_name, selected_recipe.item1_amount))
		%CraftingSlot2.set_item(selected_recipe.item2, selected_recipe.item2_amount, player.inventory.has_item(selected_recipe.item2.item_name, selected_recipe.item2_amount))
		%Result.set_item(selected_recipe.result)
	
		if player.inventory.has_item(selected_recipe.item1.item_name) and player.inventory.has_item(selected_recipe.item2.item_name):
			%CraftButton.disabled = false
		else:
			%CraftButton.disabled = true
	for recipe in %Recipes.get_children():
		if recipe.recipe.requires_crafting_table():
			if is_crafting_table:
				if recipe.recipe.tool == selected_tool or recipe.recipe.tool == Recipe.CraftingTool.NONE:
					recipe.show()
				else:
					recipe.hide()
			else:
				recipe.hide()
	
	# Tool Buttons
	for button : Button in %Tools.get_children():
		if button.tool != selected_tool:
			button.button_pressed = false
		else:
			button.button_pressed = true


func _on_craft_pressed() -> void:
	craft(selected_recipe)
