extends Control

func set_item(item_stack : ItemStack, avaliable = true) -> void:
	if item_stack != null:
		$ItemTexture.texture = item_stack.item.texture
		
		if item_stack.amount > 1:
			$Amount.text = str(item_stack.amount)
			$Amount.show()
		else:
			$Amount.hide()
		
		if avaliable:
			$ItemTexture.self_modulate = Color(1, 1, 1, 1)
			$Amount.self_modulate = Color(1, 1, 1, 1)
		else:
			$ItemTexture.self_modulate = Color(1, 1, 1, 0.5)
			$Amount.self_modulate = Color(1, 0, 0, 1)
	else:
		$ItemTexture.texture = null
		$Amount.hide()


func set_tool(tool : CraftingTool):
	if tool != null:
		$ItemTexture.texture = tool.texture
		$ItemTexture.self_modulate = Color(1, 1, 1, 1)
		$Amount.hide()
