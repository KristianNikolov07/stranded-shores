extends PanelContainer

signal closed

func _ready() -> void:
	hide()
	add_godot_license()


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("esc"):
			_on_back_pressed()
			accept_event()


func _on_back_pressed() -> void:
	hide()
	closed.emit()


func add_godot_license() -> void:
	%Godot.text = Engine.get_license_text()
