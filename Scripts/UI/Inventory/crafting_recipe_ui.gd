extends Control

signal recipe_selected(recipe : Recipe)

@export var recipe : Recipe

func _ready() -> void:
	%Item1.texture = recipe.item1.item.texture
	if recipe.item2 != null:
		%Item2.texture = recipe.item2.item.texture
	else:
		%Item2.texture = recipe.tool.texture
	%Result.texture = recipe.result.item.texture
	if recipe.item1.amount > 1:
		%Item1Amount.text = str(recipe.item1.amount)
		%Item1Amount.show()
	if recipe.item2 != null and recipe.item2.amount > 1:
		%Item2Amount.text = str(recipe.item1.amount)
		%Item2Amount.show()


func _on_texture_button_pressed() -> void:
	recipe_selected.emit(recipe)
