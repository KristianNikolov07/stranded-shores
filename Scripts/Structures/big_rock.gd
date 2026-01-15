extends Structure

func destroy() -> void:
	# Objective
	Global.get_player().objectives.complete_objective("mining")
