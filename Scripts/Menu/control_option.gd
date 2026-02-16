extends HBoxContainer

@export var action : String
@export var key : String

var is_rebinding = false

func _ready() -> void:
	$Label.text = action
	$RebindButton.text = key.replace(" - Physical", "").lstrip(" ").rstrip(" ")


func _input(event: InputEvent) -> void:
	if is_rebinding:
		if event.is_pressed():
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			key = event.as_text()
			$RebindButton.text = key.replace(" - Physical", "").lstrip(" ").rstrip(" ")
			$RebindButton.button_pressed = false
			is_rebinding = false
			accept_event()


func _on_rebind_button_pressed() -> void:
	is_rebinding = true
	$RebindButton.text = "< " + $RebindButton.text + " >"
	$RebindButton.button_pressed = true
