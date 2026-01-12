extends Control

func set_item(item : Item, amount : int = 1, avaliable = true) -> void:
	if item != null:
		$ItemTexture.texture = item.texture
		
		if amount > 1:
			$Amount.text = str(amount)
			$Amount.show()
		else:
			$Amount.hide()
		
		if avaliable:
			$ItemTexture.self_modulate = Color(1, 1, 1, 1)
			$Amount.self_modulate = Color(1, 1, 1, 1)
		else:
			$ItemTexture.self_modulate = Color(1, 1, 1, 0.5)
			$Amount.self_modulate = Color(1, 1, 1, 0.5)
	else:
		$ItemTexture.texture = null
		$Amount.hide()


func set_tool(tool : CraftingTool):
	if tool != null:
		$ItemTexture.texture = tool.texture
		$Amount.hide()
