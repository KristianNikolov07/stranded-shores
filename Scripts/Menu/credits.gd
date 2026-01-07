extends PanelContainer

signal closed

func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("esc"):
			_on_back_pressed()
			accept_event()


func _on_back_pressed() -> void:
	hide()
	closed.emit()
