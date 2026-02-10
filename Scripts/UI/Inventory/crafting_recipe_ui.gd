extends Control

signal recipe_selected(recipe : Recipe)

@export var recipe : Recipe

func _ready() -> void:
	%Item1.texture = recipe.item1.texture
	if recipe.item2 != null:
		%Item2.texture = recipe.item2.texture
	else:
		%Item2.texture = recipe.tool.texture
	%Result.texture = recipe.result.texture
	if recipe.item1_amount > 1:
		%Item1Amount.text = str(recipe.item1_amount)
		%Item1Amount.show()
	if recipe.item2_amount > 1:
		%Item2Amount.text = str(recipe.item2_amount)
		%Item2Amount.show()


func _on_texture_button_pressed() -> void:
	recipe_selected.emit(recipe)


func _on_texture_button_focus_entered() -> void:
	if Global.is_using_controller:
		$ControllerSelector.show()


func _on_texture_button_focus_exited() -> void:
	$ControllerSelector.hide()


func focus() -> void:
	$TextureButton.grab_focus()
